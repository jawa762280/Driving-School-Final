
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../core/services/crud.dart';
import '../core/services/pusher_service.dart';
import '../core/constant/app_api.dart';
import '../main.dart';

class ChatPeopleController extends GetxController {
  final Crud crud = Crud();
  final PusherService _pusher = Get.find<PusherService>();

  var isLoading = false.obs;
  List<Map<String, dynamic>> peoples = [];
  List<Map<String, dynamic>> searchList = [];
  final search = TextEditingController();
  Map<int, int> unreadByConv = {};
  var totalUnread = 0.obs;

  final Set<String> _subscribed = {};

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([fetchTotalUnread(), _loadConversations()]);
    await _subscribeAll();
  }

  Future<void> _loadConversations() async {
    isLoading.value = true; update();
    final resp = await crud.getRequest(AppLinks.chatConversations);
    isLoading.value = false;
    if (resp['data'] != null) {
      final raw = (resp['data'] as List).cast<Map<String, dynamic>>();
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
    if (resp?['unread_count'] != null) totalUnread.value = resp['unread_count'];
    update();
  }

  Future<void> fetchUnreadByConversation() async {
    final resp = await crud.getRequest(AppLinks.unreadCountByConversation);
    if (resp?['conversations'] != null) {
      unreadByConv.clear();
      for (var c in resp['conversations']) {
        unreadByConv[c['conversation_id']] = c['unread_count'];
      }
    }
    update();
  }

  Future<void> _subscribeAll() async {
    for (var chat in peoples) {
      final chan = 'private-chat.${chat['id']}';
      if (_subscribed.contains(chan)) continue;

      await _pusher.subscribeChannel(chan, (dynamic rawEvent) {
        final ev = rawEvent as PusherEvent;
        if (ev.eventName != 'App\\Events\\MessageSent') return rawEvent;
        fetchTotalUnread();
        fetchUnreadByConversation();
        _loadConversations();
        return rawEvent;
      });

      _subscribed.add(chan);
    }
  }

  Future<void> resubscribeChannels() async => _subscribeAll();

  void onSearch() {
    final q = search.text.trim().toLowerCase();
    searchList = q.isEmpty
      ? List.from(peoples)
      : peoples.where((chat) {
        final other = getOtherUser(chat);
        return other['name'].toString().toLowerCase().contains(q);
      }).toList();
    update();
  }

  Map<String, dynamic> getOtherUser(Map<String, dynamic> chat) {
    final myId = data.read('user')['id'];
    return chat['receiver_id']==myId
      ? Map.from(chat['sender'])
      : Map.from(chat['receiver']);
  }

  String getLastMessage(Map<String, dynamic> chat) {
    final msgs = (chat['messages'] as List).cast<Map<String, dynamic>>();
    return msgs.isEmpty ? '' : msgs.last['content'] ?? '';
  }

  String getLastMessageTime(Map<String, dynamic> chat) {
    final msgs = (chat['messages'] as List).cast<Map<String, dynamic>>();
    return msgs.isEmpty ? '' : msgs.last['created_at'] ?? '';
  }

  bool isLastMessageMine(Map<String, dynamic> chat) {
    final myId = data.read('user')['id'].toString();
    final msgs = (chat['messages'] as List).cast<Map<String, dynamic>>();
    return msgs.isNotEmpty && msgs.last['sender_id'].toString()==myId;
  }

  int unreadCount(Map<String, dynamic> chat) =>
    unreadByConv[chat['id']] ?? 0;

  String formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
  }

  void updateConversationTime(int convId, String newIso) {
    for (var c in peoples) {
      if (c['id']==convId) c['updated_at']=newIso;
    }
    onSearch();
    update();
  }

  void markConversationRead(int convId) {
    unreadByConv[convId] = 0;
    totalUnread.value = unreadByConv.values.fold(0,(a,b)=>a+b);
    update();
  }
  Future<void> getPeoples() async {
    isLoading.value = true; update();
    final resp = await crud.getRequest(AppLinks.chatConversations);
    isLoading.value = false;

    if (resp['data'] != null) {
      final raw = (resp['data'] as List).cast<Map<String, dynamic>>();
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
}
