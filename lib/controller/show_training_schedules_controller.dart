import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShowTrainingSchedulesController extends GetxController {
  final Crud crud = Crud();
  final GetStorage data = GetStorage();

  List<Map<String, dynamic>> scheduleList = [];
  var isLoading = true.obs; // observable boolean

  int? externalTrainerId;

  void setTrainerId(int id) {
    // ignore: avoid_print
    print("Set externalTrainerId: $id"); // طباعة

    externalTrainerId = id;
    fetchTrainerSchedule();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      if (externalTrainerId == null) {
        fetchTrainerSchedule();
      }
    });
  }

  void fetchTrainerSchedule() async {
    isLoading.value = true;
    update();

    final user = data.read('user');
    final role = data.read('role') ?? '';

    if (user == null) {
      Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم");
      isLoading.value = false;
      update();
      return;
    }

    final trainerId = externalTrainerId?.toString() ??
        (role == 'trainer' ? user['trainer']['id']?.toString() : null);

    // ignore: avoid_print
    print("Fetching schedules for trainerId: $trainerId"); // طباعة

    // ✅ أوقف التنفيذ إذا trainerId غير متوفّر
    if (trainerId == null) {
      // ignore: avoid_print
      print("⚠️ لم يتم تحديد trainerId بعد، سيتم تجاهل الطلب.");
      isLoading.value = false;
      update();
      return;
    }

    final url = "${AppLinks.showTRainingSchedules}/$trainerId/schedules";

    final response = await crud.getRequest(url);

    if (response != null && response['data'] != null) {
      scheduleList = List<Map<String, dynamic>>.from(
        response['data'].where((e) => e is Map<String, dynamic>),
      );
    } else {
      Get.snackbar("خطأ", "فشل في تحميل الجداول");
    }

      isLoading.value = false;
    update();
  }
}
