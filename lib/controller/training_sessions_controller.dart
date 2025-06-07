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

  late final bool isTrainer;
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
    initTrainerIdAndFetch();
  }

  void initTrainerIdAndFetch() {
    final user = data.read('user');
    final role = data.read('role') ?? '';

    isTrainer = role == 'trainer';

    // أولاً: إذا تم تمرير trainer_id عبر arguments
    trainerId = Get.arguments?['trainer_id']?.toString();

    // ثانياً: إذا لم يتم تمريره، نحاول من التخزين المحلي
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
}
