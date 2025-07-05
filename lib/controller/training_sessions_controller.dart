import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TrainingSessionsController extends GetxController {
  final Crud crud = Crud();
  final GetStorage data = GetStorage();

  var isLoading = true.obs;
  var sessionsData = <dynamic>[].obs;
  var errorMessage = ''.obs;
  var selectedDayIndex = 0.obs;

bool isTrainer = false;
  String? trainerId;

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }

  void setTrainerId(int id) {
    trainerId = id.toString();
    fetchTrainingSessions();
  }

  @override
void onInit() {
  super.onInit();
  final args = Get.arguments;

  if (args != null && args['schedule_id'] != null) {
    fetchSessionsByScheduleId(args['schedule_id']);
  } else if (args != null && args['trainer_id'] != null) {
    setTrainerId(args['trainer_id']);
  } else {
    initTrainerIdAndFetch();
  }
}


  void initTrainerIdAndFetch() {
    final user = data.read('user');
    final role = data.read('role') ?? '';

    isTrainer = role == 'trainer';

    trainerId = Get.arguments?['trainer_id']?.toString();

    trainerId ??= user?['trainer']['id']?.toString();

    if (trainerId == null) {
      errorMessage.value = 'لم يتم تحديد المدرب';
      isLoading.value = false;
      return;
    }

    fetchTrainingSessions();
  }

  Future<void> fetchTrainingSessions() async {
    isLoading.value = true;
    errorMessage.value = '';

    final url = "${AppLinks.trainingSessions}?trainer_id=$trainerId";
    final response = await crud.getRequest(url);

    if (response != null && response['data'] != null) {
      sessionsData.value = response['data'];
    } else {
      errorMessage.value = 'فشل في تحميل الجلسات';
    }

    isLoading.value = false;
  }
  Future<void> fetchSessionsByScheduleId(int scheduleId) async {
  isLoading.value = true;
  errorMessage.value = '';

  final url = "${AppLinks.trainerSessionsBySchedule}?schedule_id=$scheduleId";
  final response = await crud.getRequest(url);

  if (response != null && response['data'] != null) {
    sessionsData.value = response['data'];
  } else {
    errorMessage.value = 'فشل في تحميل الجلسات حسب الجدول';
  }

  isLoading.value = false;
}

}
