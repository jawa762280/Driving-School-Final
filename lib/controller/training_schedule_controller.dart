import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:get/get.dart';

class TrainingScheduleController extends GetxController {
  var isLoading = true.obs;
  var sessionsData = <dynamic>[].obs;
  var errorMessage = ''.obs;
  Crud crud = Crud();
  var selectedDayIndex = 0.obs;

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchTrainingSessions();
  }

  Future<void> fetchTrainingSessions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final trainer = data.read('user');
      final trainerId =
          trainer != null ? trainer['trainer_id'].toString() : null;

      var response = await crud
          .getRequest('${AppLinks.trainingSessions}?trainer_id=$trainerId');

      if (response != null && response['data'] != null) {
        sessionsData.value = response['data'];
      } else if (response != null && response['statusCode'] == 401) {
        errorMessage.value = 'غير مخول (401)';
      } else {
        errorMessage.value = 'حدث خطأ أثناء جلب البيانات';
      }
    } catch (e) {
      errorMessage.value = 'فشل الاتصال بالخادم';
    } finally {
      isLoading.value = false;
    }
  }
}
