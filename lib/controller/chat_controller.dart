import 'dart:async';
import 'dart:io';
import 'package:driving_school/controller/chat_people_controller.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/services/crud.dart';

class ChatController extends GetxController {
  final Crud crud = Crud();
  var isSending = false.obs;
  bool _firstLoadDone = false;
  List<Map<String, dynamic>> chatMessages = [];
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String? toID;
  String? name;
  int? conversationId;

  bool chatLoading = false;
  File? file;
  double bottomMargin = 50;

  Timer? _pollingTimer;
  late StreamSubscription<RemoteMessage> _fcmSub;

  @override
  void onInit() {
    super.onInit();

    // 1) استقبل args من الواجهة
    toID = Get.arguments['to_id']?.toString();
    name = Get.arguments['name']?.toString();
    conversationId =
        int.tryParse(Get.arguments['conversation_id']?.toString() ?? '');
    if (conversationId == null) {
      throw Exception('conversation_id missing!');
    }
    _firstLoadDone = false;

    // 2) جلب السجل التاريخي أولاً 
    _loadHistory().then((_) => scrollToBottom());

    // 3) جدولة polling كل ثانيتين
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) async {
        await _loadHistory();
      },
    );

    // 4) استماع لإشعارات FCM في الواجهة الأمامية
    _fcmSub = FirebaseMessaging.onMessage.listen((msg) {
      print('🔔 FCM onMessage: ${msg.notification?.title}');
      _loadHistory().then((_) => scrollToBottom());
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    _fcmSub.cancel();
    super.onClose();
  }

  /// دالة مساعدة لتمييز أن الرسالة من عندي أنا
  bool isMe(Map<String, dynamic> msg) {
    final myId = data.read('user')['id'].toString();
    return msg['sender_id'].toString() == myId || (msg['is_me'] == true);
  }

  /// getter بسيط للمعلومات الأساسية عن الطرف الآخر
  Map<String, dynamic> get otherUser => {
        'id': toID,
        'name': name,
      };

  /// تنسيق timestamp من ISO إلى HH:mm
  String formatTime(String? isoString) {
    if (isoString == null) return '';
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return '';
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _loadHistory() async {
    // 1) احفظ عدد الرسائل قبل التحديث
    final prevLen = chatMessages.length;

    // 2) جلب المحادثة من السيرفر
    final url = '${AppLinks.chatMessages}/$conversationId';
    final resp = await crud.getRequest(url);

    if (resp['data'] != null) {
      // 3) حدّث القائمة
      chatMessages = List<Map<String, dynamic>>.from(resp['data']);
      update();

      // 4) علّم الرسائل مقروءة **مرة واحدة فقط** (أول تحميل)
      if (!_firstLoadDone) {
        final myId = data.read('user')['id'].toString();
        for (var msg in chatMessages) {
          if (msg['sender_id'].toString() != myId &&
              (msg['is_read'] == 0 || msg['is_read'] == false)) {
            await _markMessageRead(msg['id']);
            msg['is_read'] = 1;
          }
        }
        update();
      }

      // 5) سكّروول أوتوماتيكي عند أول تحميل أو عند وصول رسائل جديدة
      if (!_firstLoadDone || chatMessages.length > prevLen) {
        scrollToBottom();
        _firstLoadDone = true;
      }
    }
  }

  Future<void> _markMessageRead(int messageId) async {
    try {
      final resp = await crud.postRequest(
        AppLinks.markMessageRead,
        {'message_id': messageId},
      );
      if (resp != null && resp['status'] == true) {
        print('✔️ Message $messageId marked as read');
      } else {
        print('⚠️ Failed to mark $messageId as read: $resp');
      }
    } catch (e) {
      print('❌ Error in _markMessageRead: $e');
    }
  }

  Future<void> sendMessage() async {
  final content = textController.text.trim();
  if (content.isEmpty || isSending.value) return;

  isSending.value = true;
  update();

  try {
    final resp = await crud.postRequest(AppLinks.sendMessages, {
      'receiver_id': toID,
      'content': content,
    });

    if (resp != null && resp['data'] != null) {
      final msgData = resp['data'];

      // أضف الرسالة للمحادثة الحالية
      chatMessages.add({
        'id': msgData['id'],
        'sender_id': data.read('user')['id'],
        'content': content,
        'date': msgData['created_at'],
        'is_me': true,
        'is_read': 1,
      });

      // حدّث آخر وقت للمحادثة
      final nowIso = msgData['created_at'] ?? DateTime.now().toIso8601String();
      // في حالة عرض شاشة ChatPeopleScreen ضمن GetBuilder واحد،
      // يمكنك إرسال حدث إعادة تحميل للمحادثات:
      Get.find<ChatPeopleController>().updateConversationTime(conversationId!, nowIso);

      textController.clear();
      scrollToBottom();
    }
  } finally {
    isSending.value = false;
    update();
  }
}


  Future<void> openFiles() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      await sendMessage();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
