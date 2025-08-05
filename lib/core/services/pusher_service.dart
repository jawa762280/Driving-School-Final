
import 'dart:convert';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:crypto/crypto.dart';

class PusherService extends GetxService {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter();
  final _subs = <String>{};

  String _getSignature(String data) {
    final key = utf8.encode('f0fcdbf6eb3d8193b3bd');
    return Hmac(sha256, key).convert(utf8.encode(data)).toString();
  }

  Future<dynamic> _authorizer(String channel, String socketId, _) async {
    final sig = _getSignature('$socketId:$channel');
    return {'auth': 'b86e117cb7e9945a345b:$sig'};
  }

  Future<PusherService> init() async {
    await pusher.init(
      apiKey: 'b86e117cb7e9945a345b',
      cluster: 'eu',
      onAuthorizer: _authorizer,
      onConnectionStateChange: (curr, prev) =>
          // ignore: avoid_print
          print('🔌 PusherService: $prev ➡ $curr'),
      // ignore: avoid_print
      onError: (msg, code, ex) => print('❌ PusherService Error: $msg'),
    );
    await pusher.connect();
    return this;
  }

  bool hasSubscribed(String channelName) => _subs.contains(channelName);
  

  Future<void> subscribeChannel(
    String channelName,
    dynamic Function(dynamic) onEvent,
  ) async {
    if (_subs.contains(channelName)) {
      // ignore: avoid_print
      print('⚠ Already subscribed to $channelName');
      return;
    }
    await pusher.subscribe(
      channelName: channelName,
      onEvent: onEvent,
    );
    // ignore: avoid_print
    print('✅ Subscribed to $channelName');
    _subs.add(channelName);
  }

  Future<void> unsubscribeChannel(String channelName) async {
    if (!_subs.contains(channelName)) return;
    await pusher.unsubscribe(channelName: channelName);
    // ignore: avoid_print
    print('❌ Unsubscribed from $channelName');
    _subs.remove(channelName);
  }
}
