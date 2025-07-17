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
  // خليها RxList عشان GetX يلتقط التغييرات
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // أول جلب
    fetchNotifications();
    // وشغل polling كل 30 ثانية
    timer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchNotifications();
    });
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  Future<void> fetchNotifications() async {
    // حفظ عدد غير المقروءين قبل التحديث
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

    // حدّد نوع العناصر إلى Map<String, dynamic>
    notifications.value =
        rawList.map((e) => e as Map<String, dynamic>).toList();

    isLoading(false);

    // قارن عدد غير المقروءين بعد التحديث
    final newCount = notifications.where((n) => n['read_at'] == null).length;
    if (newCount > prevCount) {
      _playNotificationSound();
    }
  }

  void _playNotificationSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/mixkit-confirmation-tone-2867.wav'));
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
