import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';

class NotificationsController extends GetxController {
  final Crud _crud = Crud();
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Timer timer;

  var isLoading = true.obs;
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    // وشغل polling كل 30 ثانية
    // timer = Timer.periodic(const Duration(seconds: 30), (_) {
    //   fetchNotifications();
    // });
  }

  @override
  void onClose() {
    // timer.cancel();
    super.onClose();
  }

  Future<void> fetchNotifications() async {
    final prevCount = notifications.where((n) => n['read_at'] == null).length;

    isLoading(true);
    final response = await _crud.getRequest(AppLinks.notifications);

    List<dynamic> rawList;
    if (response is List) {
      rawList = response;
    } else if (response is Map && response['data'] is List) {
      rawList = response['data'];
    } else {
      rawList = [];
    }

    notifications.value =
        rawList.map((e) => e as Map<String, dynamic>).toList();

    isLoading(false);

    final newCount = notifications.where((n) => n['read_at'] == null).length;
    if (newCount > prevCount) {
      _playNotificationSound();
    }
  }

  void _playNotificationSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer
          .play(AssetSource('sounds/mixkit-confirmation-tone-2867.wav'));
    } catch (e) {
      // ignore: avoid_print
      print('🔴 Error playing sound: $e');
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    final response = await _crud.postRequest(
      "${AppLinks.notifications}/$id/mark-read",
      {},
    );
    if (response != null && response['message'] == "Marked as read") {
      final idx = notifications.indexWhere((n) => n['id'].toString() == id);
      if (idx != -1) {
        notifications[idx]['read_at'] = DateTime.now().toIso8601String();
        notifications.refresh();
      }
    } else {
      Get.snackbar("خطأ", "فشل في تحديث حالة الإشعار");
    }
  }

  Future<void> markAllAsRead() async {
    for (var n in notifications) {
      if (n['read_at'] == null) {
        await markNotificationAsRead(n['id'].toString());
      }
    }
  }
}
