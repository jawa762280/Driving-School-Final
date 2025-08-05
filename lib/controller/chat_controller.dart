
import 'dart:convert';
import 'package:driving_school/main.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../core/services/crud.dart';
import '../core/services/pusher_service.dart';
import '../core/constant/app_api.dart';
import 'chat_people_controller.dart';

class ChatController extends GetxController {
  final Crud crud = Crud();
  final PusherService pusher = Get.find<PusherService>();
  double bottomMargin = 50;
  var isSending = false.obs;
  bool _firstLoadDone = false;
  List<Map<String, dynamic>> chatMessages = [];
  final textController = TextEditingController();
  final scrollController = ScrollController();

  String? toID;
  String? name;
  int? conversationId;

  Map<String, dynamic> get otherUser => {
        'id': toID,
        'name': name,
      };

  @override
  void onInit() {
    super.onInit();
    toID = Get.arguments['to_id']?.toString();
    name = Get.arguments['name']?.toString();
    final arg = Get.arguments['conversation_id'];
    conversationId = arg != null ? int.tryParse(arg.toString()) : null;

    if (conversationId != null) {
      _loadHistory().then((_) => scrollToBottom());
      _subscribe();
    }
  }

  void _subscribe() {
    if (conversationId == null) return;
    final channel = 'private-chat.$conversationId';

    if (pusher.hasSubscribed(channel)) return;

    pusher.subscribeChannel(channel, (dynamic rawEvent) {
      final ev = rawEvent as PusherEvent;
      if (ev.eventName != 'App\\Events\\MessageSent') return rawEvent;

      final decoded = jsonDecode(ev.data ?? '{}');
      final msg = decoded['message'] ?? decoded;
      final id = msg['id'];
      if (chatMessages.any((m) => m['id'] == id)) return rawEvent;

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
      return rawEvent;
    });
  }

  @override
  void onClose() {
    if (conversationId != null) {
      pusher.unsubscribeChannel('private-chat.$conversationId');
    }
    super.onClose();
  }

  Future<void> _loadHistory() async {
    final resp =
        await crud.getRequest('${AppLinks.chatMessages}/$conversationId');
    if (resp['data'] != null) {
      chatMessages = List<Map<String, dynamic>>.from(resp['data']);
      update();

      if (!_firstLoadDone) {
        final myId = data.read('user')['id'].toString();
        for (var m in chatMessages) {
          if (m['sender_id'].toString() != myId &&
              (m['is_read'] == 0 || m['is_read'] == false)) {
            await crud
                .postRequest(AppLinks.markMessageRead, {'message_id': m['id']});
          }
        }
        if (Get.isRegistered<ChatPeopleController>()) {
          final ppl = Get.find<ChatPeopleController>();
          ppl.markConversationRead(conversationId!);
          await ppl.fetchTotalUnread();
          await ppl.fetchUnreadByConversation();
        }
        _firstLoadDone = true;
      }
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
      if (resp?['data'] != null) {
        final msg = resp['data'];
        if (conversationId == null) {
          conversationId = msg['conversation_id'] as int;
          _subscribe();
        }
        chatMessages.add({
          'id': msg['id'],
          'sender_id': data.read('user')['id'],
          'content': content,
          'created_at': msg['created_at'],
          'is_me': true,
          'is_read': true,
        });
        Get.find<ChatPeopleController>()
            .updateConversationTime(conversationId!, msg['created_at']);
        textController.clear();
        scrollToBottom();
      }
    } finally {
      isSending.value = false;
      update();
    }
  }

  Future<void> sendFileMessage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );
    if (res == null) return;
    final file = XFile(res.files.single.path!);
    isSending.value = true;
    update();

    try {
      final resp = await crud.multiFileRequestMoreImagePath(
        AppLinks.sendMessages,
        {'receiver_id': toID!},
        [file],
        ['file'],
      );
      if (resp?['data'] != null) {
        final msg = resp['data'];
        chatMessages.add({
          'id': msg['id'],
          'sender_id': data.read('user')['id'],
          'content': msg['content'] ?? '',
          'file_url': msg['file_url'],
          'created_at': msg['created_at'],
          'is_me': true,
          'is_read': true,
          'type': 'file',
        });
        scrollToBottom();
      }
    } finally {
      isSending.value = false;
      update();
    }
  }

  Future<void> openFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );
    if (result == null) return;
    await sendFileMessage();
  }

  bool isMe(Map<String, dynamic> m) =>
      m['sender_id'].toString() == data.read('user')['id'].toString();

  String formatTime(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.parse(iso);
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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
