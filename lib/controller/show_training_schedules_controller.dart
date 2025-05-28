import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

    final trainer = data.read('user');
    final trainerId = trainer != null ? trainer['trainer_id'].toString() : null;

    if (trainerId == null) {
      Get.snackbar("خطأ", "لم يتم العثور على معرف المدرب");
      isLoading = false;
      update();
      return;
    }

    final response = await crud
        .getRequest("${AppLinks.showTRainingSchedules}/$trainerId/schedules");

    if (response != null && response['data'] != null) {
      scheduleList = List<Map<String, dynamic>>.from(response['data']);
    } else {
      Get.snackbar("خطأ", "فشل في تحميل الجداول");
    }

    isLoading = false;
    update();
  }
}
