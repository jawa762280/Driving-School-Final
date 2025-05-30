import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/widgets.dart';

class ShowTRainingSchedulesController extends GetxController {
  Crud crud = Crud();
  final GetStorage data = GetStorage();

  List<Map<String, dynamic>> scheduleList = [];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchTrainerSchedule();
  }

  void fetchTrainerSchedule() async {
    isLoading = true;
    update();

    final user = data.read('user'); // لو بدك بيانات المستخدم

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم");
      });
      isLoading = false;
      update();
      return;
    }

    // هنا نقرأ الدور من بيانات المستخدم مباشرة
    final role = data.read('role') ?? '';

    if (role == null || (role != 'trainer' && role != 'student')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("خطأ", "دور المستخدم غير معروف");
      });
      isLoading = false;
      update();
      return;
    }

    final trainerId = user['trainer_id']?.toString();
    final studentId = user['student_id']?.toString();

    final url = role == 'trainer'
        ? "${AppLinks.showTRainingSchedules}/$trainerId/schedules"
        : "${AppLinks.showTRainingSchedules}/$studentId/schedules";

    final response = await crud.getRequest(url);

    if (response != null && response['data'] != null) {
      scheduleList = List<Map<String, dynamic>>.from(
        response['data'].where((e) => e is Map<String, dynamic>),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("خطأ", "فشل في تحميل الجداول");
      });
    }

    isLoading = false;
    update();
  }
}
