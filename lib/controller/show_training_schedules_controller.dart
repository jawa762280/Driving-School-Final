import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShowTrainingSchedulesController extends GetxController {
  final Crud crud = Crud();
  final GetStorage data = GetStorage();

  List<Map<String, dynamic>> scheduleList = [];
  bool isLoading = true;

  int? externalTrainerId;

  void setTrainerId(int id) {
    externalTrainerId = id;
    fetchTrainerSchedule();
  }

  @override
  void onInit() {
    super.onInit();

    // في حالة تم استدعاؤه بدون تمرير ID خارجي (يعني من مدرب نفسه)
    if (externalTrainerId == null) {
      fetchTrainerSchedule();
    }
  }

  void fetchTrainerSchedule() async {
    isLoading = true;
    update();

    final user = data.read('user');
    final role = data.read('role') ?? '';

    if (user == null) {
      Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم");
      isLoading = false;
      update();
      return;
    }

    // نحدد المعرف حسب الدور
    final trainerId = role == 'trainer'
        ? user['trainer_id']?.toString()
        : externalTrainerId?.toString();

    final url = "${AppLinks.showTRainingSchedules}/$trainerId/schedules";

    final response = await crud.getRequest(url);

    if (response != null && response['data'] != null) {
      scheduleList = List<Map<String, dynamic>>.from(
        response['data'].where((e) => e is Map<String, dynamic>),
      );
    } else {
      Get.snackbar("خطأ", "فشل في تحميل الجداول");
    }

    isLoading = false;
    update();
  }
}
