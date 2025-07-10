import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';

class NotificationsController extends GetxController {
  final Crud _crud = Crud();

  var isLoading = true.obs;
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading(true);
    final response = await _crud.getRequest(AppLinks.notifications);
    if (response != null) {
      notifications.value = List<Map<String, dynamic>>.from(response);
    } else {
      Get.snackbar("خطأ", "فشل في تحميل الإشعارات");
    }
    isLoading(false);
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
