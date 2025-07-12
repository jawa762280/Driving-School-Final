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
  timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    fetchNotifications();
  });
}
  @override
void onClose() {
  timer.cancel();
  super.onClose();
}

  Future<void> fetchNotifications() async {
    final prevCount = notifications.where((n) => n['read_at'] == null).length;

    final response = await _crud.getRequest(AppLinks.notifications);
    if (response != null) {
      notifications.value = List<Map<String, dynamic>>.from(response);

      final newCount = notifications.where((n) => n['read_at'] == null).length;

      // ✅ إذا في إشعار جديد، شغل صوت
      if (newCount > prevCount) {
        _playNotificationSound();
      }
    } else {
      Get.snackbar("خطأ", "فشل في تحميل الإشعارات");
    }

    isLoading(false);
  }

  void _playNotificationSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer
          .play(AssetSource('sounds/mixkit-confirmation-tone-2867.wav'));
    } catch (e) {
      print('🔴 Error playing sound: $e');
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    final response = await _crud.postRequest(
      "${AppLinks.notifications}/$id/mark-read",
      {},
    );

    if (response != null && response['message'] == "Marked as read") {
      final index = notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        notifications[index]['read_at'] = DateTime.now().toIso8601String();
        notifications.refresh();
      }
    } else {
      Get.snackbar("خطأ", "فشل في تحديث حالة الإشعار");
    }
  }

  Future<void> markAllAsRead() async {
    for (var notification in notifications) {
      if (notification['read_at'] == null) {
        await markNotificationAsRead(notification['id']);
      }
    }
  }
}
