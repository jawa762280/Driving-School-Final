// lib/controller/chat_people_controller.dart

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatPeopleController extends GetxController {
  final Crud crud = Crud();
  bool isLoading = false;
  late PusherChannelsFlutter pusher;

  List<Map<String, dynamic>> peoples = [];
  List<Map<String, dynamic>> searchList = [];
  TextEditingController search = TextEditingController();

  /// خريطة لتخزين عدد غير المقروءة لكل محادثة
  Map<int, int> unreadByConv = {};

  /// العدد الكلّي للرسائل غير المقروءة
  var totalUnread = 0.obs;

  @override
  void onInit() async {
    // 1) جلب عدد المستجدات وقائمة المحادثات أولاً
    await Future.wait([
      fetchTotalUnread(),
      getPeoples(),
    ]);

    // 2) ثم تهيئة Pusher بعد وجود peoples
    await _initPusher();

    super.onInit();
  }

  Future<void> getPeoples() async {
    isLoading = true;
    update();

    final resp = await crud.getRequest(AppLinks.chatConversations);
    isLoading = false;

    if (resp['data'] != null) {
      final raw = (resp['data'] as List).cast<Map<String, dynamic>>();
      // دمج المحادثات الفريدة
      final map = <String, Map<String, dynamic>>{};
      for (var c in raw) {
        final sid = c['sender_id'], rid = c['receiver_id'];
        final key = List.of([sid, rid])..sort();
        map['${key[0]}-${key[1]}'] = c;
      }
      peoples = map.values.toList();
      searchList = List.from(peoples);

      await fetchUnreadByConversation();
    }

    update();
  }

  Future<void> fetchTotalUnread() async {
    final resp = await crud.getRequest(AppLinks.unreadCount);
    if (resp != null && resp['unread_count'] != null) {
      totalUnread.value = resp['unread_count'] as int;
    }
    update();
  }

  Future<void> fetchUnreadByConversation() async {
    final resp = await crud.getRequest(AppLinks.unreadCountByConversation);
    if (resp != null && resp['conversations'] != null) {
      for (var c in resp['conversations']) {
        unreadByConv[c['conversation_id']] = c['unread_count'];
      }
    }
    update();
  }

  /// 2) اشتراك في قنوات المحادثات
  Future<void> _initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();
    await pusher.init(
      apiKey: "b86e117cb7e9945a345b",
      cluster: "eu",
      onAuthorizer: _onAuthorizer,
      onConnectionStateChange: (c, p) => print("🔌 Pusher(people): $p ➡ $c"),
      onSubscriptionSucceeded: (chan, _) => print("✅ Subscribed to $chan"),
      onError: (msg, code, e) => print("❌ Pusher Error(people): $msg"),
      onEvent: (event) {
        if (event.eventName == 'App\\Events\\MessageSent') {
          // 3) عند كل رسالة واردة: جلب جديد وإعادة رسم الواجهة تلقائياً
          fetchTotalUnread();
          fetchUnreadByConversation();
          getPeoples();
        }
      },
    );

    // اشترك في كل قناة محادثة
    for (var chat in peoples) {
      await pusher.subscribe(channelName: 'private-chat.${chat['id']}');
    }

    // أطلق الاتصال أخيراً
    await pusher.connect();
  }

  String _getSignature(String data) {
    final key = utf8.encode('f0fcdbf6eb3d8193b3bd');
    return Hmac(sha256, key).convert(utf8.encode(data)).toString();
  }

  Future<dynamic> _onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    final sig = _getSignature('$socketId:$channelName');
    return {'auth': 'b86e117cb7e9945a345b:$sig'};
  }

  @override
  void onClose() {
    pusher.disconnect();
    super.onClose();
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

  /// يعيد توقيت آخر رسالة (created_at) أو سلسلة فارغة
  String getLastMessageTime(Map<String, dynamic> chat) {
    final msgs = (chat['messages'] as List).cast<Map<String, dynamic>>();
    if (msgs.isEmpty) return '';
    return msgs.last['created_at']?.toString() ?? '';
  }

  void markConversationRead(int convId) {
    // صفر غير المقروء لهذا المحادثة
    unreadByConv[convId] = 0;

    // أعد احتساب المجموع الكلّي
    totalUnread.value = unreadByConv.values.fold(0, (a, b) => a + b);

    update();
  }
  bool isLastMessageMine(Map<String, dynamic> chat) {
  final myId = data.read('user')['id'].toString();
  final msgs = (chat['messages'] as List).cast<Map<String, dynamic>>();
  if (msgs.isEmpty) return false;
  // آخر رسالة هي msgs.last
  return msgs.last['sender_id'].toString() == myId;
}



}
