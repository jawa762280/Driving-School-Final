import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:driving_school/controller/chat_people_controller.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../core/services/crud.dart';

class ChatController extends GetxController {
  final Crud crud = Crud();

  var isSending = false.obs;
  bool _firstLoadDone = false;
  late PusherChannelsFlutter pusher;

  List<Map<String, dynamic>> chatMessages = [];
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String? toID;
  String? name;
  int? conversationId;

  bool chatLoading = false;
  File? file;
  double bottomMargin = 50;

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
    initPusher();
  }

  Future<void> initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();

    await pusher.init(
      apiKey: "b86e117cb7e9945a345b",
      cluster: "eu",
      onAuthorizer: _onAuthorizer,
      onConnectionStateChange: (current, previous) {
        print("🔌 Pusher: $previous ➡ $current");
      },
      onSubscriptionSucceeded: (channelName, _) {
        print("✅ Subscribed to $channelName");
      },
      onError: (message, code, e) {
        print("❌ Pusher Error: $message");
      },
      onEvent: (PusherEvent event) {
        if (event.eventName != 'App\\Events\\MessageSent') return;

        final decoded = jsonDecode(event.data ?? '{}');
        final msg = decoded['message'] ?? decoded;
        data.read('user')['id'].toString();
        final msgId = msg['id'];

        // **هنا الشرط الجديد**: إذا الرسالة من عندي، ما نضيفها
        final exists = chatMessages.any((m) => m['id'] == msgId);
        if (exists) return;
        chatMessages.add({
          'id': msg['id'],
          'sender_id': msg['sender_id']?.toString() ?? toID,
          'content': msg['content'],
          'created_at': msg['created_at'] ?? DateTime.now().toIso8601String(),
          'is_me': false,
          'is_read': true,
        });

        update();
        scrollToBottom();
      },
    );

    final channelName = 'private-chat.$conversationId';
    await pusher.subscribe(channelName: channelName);
    await pusher.connect();
  }

  @override
  void onClose() {
    pusher.disconnect();
    super.onClose();
  }

  /// يُرجع digest على شكل نصّ من HMAC–SHA256 لـ data باستخدام secret key
  String _getSignature(String data) {
    final secretKey =
        utf8.encode('f0fcdbf6eb3d8193b3bd'); // your PUSHER_APP_SECRET
    final bytes = utf8.encode(data);
    final hmac = Hmac(sha256, secretKey);
    final digest = hmac.convert(bytes);
    return digest.toString();
  }

  /// تُستدعى قبل الاشتراك في قناة خاصة لتعطي auth string
  Future<dynamic> _onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    final signature = _getSignature('$socketId:$channelName');
    return {
      'auth':
          'b86e117cb7e9945a345b:$signature', // your PUSHER_APP_KEY + ':' + signature
    };
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

      // 4) علّم الرسائل مقروءة مرة واحدة فقط (أول تحميل)
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
        print('✔ Message $messageId marked as read');
      } else {
        print('⚠ Failed to mark $messageId as read: $resp');
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
        final nowIso =
            msgData['created_at'] ?? DateTime.now().toIso8601String();
        // في حالة عرض شاشة ChatPeopleScreen ضمن GetBuilder واحد،
        // يمكنك إرسال حدث إعادة تحميل للمحادثات:
        Get.find<ChatPeopleController>()
            .updateConversationTime(conversationId!, nowIso);

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
