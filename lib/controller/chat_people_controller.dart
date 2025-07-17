// lib/controller/chat_people_controller.dart

import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPeopleController extends GetxController {
  final Crud crud = Crud();
  bool isLoading = false;
  List<Map<String, dynamic>> peoples = [];
  List<Map<String, dynamic>> searchList = [];
  TextEditingController search = TextEditingController();

  /// خريطة لتخزين عدد غير المقروءة لكل محادثة
  Map<int, int> unreadByConv = {};

  /// العدد الكلّي للرسائل غير المقروءة
  var totalUnread = 0.obs;

  @override
  void onInit() async {
    await Future.wait([
      fetchTotalUnread(),
      getPeoples(),
    ]);
    super.onInit();
  }

  /// يجلب العدد الكلّي للرسائل غير المقروءة
  Future<void> fetchTotalUnread() async {
    try {
      final resp = await crud.getRequest(AppLinks.unreadCount);
      if (resp != null && resp['unread_count'] != null) {
        totalUnread.value = resp['unread_count'] as int;
      }
    } catch (_) {
      // يمكنك إضافة لوج هنا في حال الفشل
    }
  }

  /// يجلب قائمة المحادثات المدموجة ويمسح المكرّرات
  Future<void> getPeoples() async {
    try {
      isLoading = true;
      update();

      final response = await crud.getRequest(AppLinks.chatConversations);
      isLoading = false;

      if (response['data'] != null) {
        final raw = response['data'] as List;
        final Map<String, Map<String, dynamic>> unique = {};
        for (var c in raw) {
          final sid = c['sender_id'], rid = c['receiver_id'];
          final keyList = [sid, rid]..sort();
          unique['${keyList[0]}-${keyList[1]}'] = c;
        }
        peoples = unique.values.toList().cast();
        searchList = List.from(peoples);

        // بعد جلب المحادثات، أحضر عدد غير المقروءة لكل محادثة
        await fetchUnreadByConversation();
      }
    } catch (e) {
      isLoading = false;
    }
    update();
  }

  /// يجلب عدد الرسائل غير المقروءة لكل محادثة على حدة
  Future<void> fetchUnreadByConversation() async {
    try {
      final resp = await crud.getRequest(AppLinks.unreadCountByConversation);
      if (resp != null && resp['conversations'] != null) {
        for (var c in resp['conversations']) {
          final id = c['conversation_id'] as int;
          final cnt = c['unread_count'] as int;
          unreadByConv[id] = cnt;
        }
      }
    } catch (_) {
      // تجاهل في حال الفشل
    }
  }

  void onSearch() {
    final q = search.text.trim().toLowerCase();
    if (q.isEmpty) {
      searchList = List.from(peoples);
    } else {
      searchList = peoples.where((chat) {
        final other = getOtherUser(chat);
        return other['name']!.toString().toLowerCase().contains(q);
      }).toList();
    }
    update();
  }

  /// يعيد بيانات الطرف الآخر في المحادثة
  Map<String, dynamic> getOtherUser(Map<String, dynamic> chat) {
    final myId = data.read('user')['id'];
    return chat['receiver_id'] == myId
        ? Map<String, dynamic>.from(chat['sender'])
        : Map<String, dynamic>.from(chat['receiver']);
  }

  /// يعيد نص آخر رسالة أو سلسلة فارغة
  String getLastMessage(Map<String, dynamic> chat) {
    final msgs = (chat['messages'] as List).cast<Map<String, dynamic>>();
    if (msgs.isEmpty) return '';
    return msgs.last['content']?.toString() ?? '';
  }

  /// يعيد عدد الرسائل غير المقروءة لهذه المحادثة
  int unreadCount(Map<String, dynamic> chat) {
    return unreadByConv[chat['id']] ?? 0;
  }

  /// ينسّق الـ timestamp إلى HH:mm
  String formatTime(String isoString) {
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return '';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void updateConversationTime(int convId, String newIso) {
    for (var chat in peoples) {
      if (chat['id'] == convId) {
        chat['updated_at'] = newIso;
        break;
      }
    }
    // أعد تطبيق البحث إذا كان مستخدماً
    onSearch();
    update();
  }
}
