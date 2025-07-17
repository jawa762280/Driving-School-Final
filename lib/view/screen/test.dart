

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TestPage extends StatefulWidget {
  @override _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    // 1) افتح اتصال WebSocket فقط (نتجنب polling للتبسيط)
    socket = IO.io(
      'http://192.168.1.107:3000',  // localhost للحاسوب من داخل المحاكي
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()    // يبدأ الاتصال تلقائيًا
        .build(),
    );

    // 2) handlers
    socket!.onConnect((_) {
      print('✅ CLIENT connected: ${socket!.id}');
      // 3) أرسل اختبار فور الاتصال
      socket!.emit('send_test');
    });
    socket!.onDisconnect((_)   => print('🔌 CLIENT disconnected'));
    socket!.onConnectError((e)  => print('❌ CLIENT connect_error: $e'));
    socket!.onError((e)         => print('❌ CLIENT error: $e'));
    socket!.on('receive_message', (msg) {
      print('📥 CLIENT receive_message: $msg');
    });
  }

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: Text('Socket.IO Test')),
    body: Center(child: Text('Check console logs')),
  );
}