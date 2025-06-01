import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/widgets.dart';

class TrainingSessionsController extends GetxController {
  Crud crud = Crud();
  final GetStorage data = GetStorage();

  var isLoading = true.obs;
  var sessionsData = <dynamic>[].obs;
  var errorMessage = ''.obs;
  var selectedDayIndex = 0.obs;

  late final bool isTrainer;
  String? trainerId;
  String? studentId;

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchTrainingSessions();
  }

  Future<void> fetchTrainingSessions() async {
    isLoading.value = true;
    errorMessage.value = '';

    final user = data.read('user');
    final role = data.read('role') ?? '';

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم");
      });
      isLoading.value = false;
      return;
    }

    if (role != 'trainer' && role != 'student') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("خطأ", "دور المستخدم غير معروف");
      });
      isLoading.value = false;
      return;
    }

    isTrainer = role == 'trainer';
    trainerId = user['trainer_id']?.toString();
    studentId = user['student_id']?.toString();

    // نستخدم trainer_id فقط سواء كان المدرب أو الطالب، لأن الجدول مبني على المدرب
    final idToUse = isTrainer ? trainerId : trainerId; // أو من عند الطالب: user['trainer_id']

    final url = "${AppLinks.trainingSessions}?trainer_id=$idToUse";
    final response = await crud.getRequest(url);

    if (response != null && response['data'] != null) {
      sessionsData.value = response['data'];
    } else {
      errorMessage.value = 'فشل في تحميل الجلسات';
    }

    isLoading.value = false;
  }
}
