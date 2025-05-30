import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/main.dart';

class ShowVacationsController extends GetxController {
  final Crud crud = Crud();

  var vacations = [].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVacations();
  }

  Future<void> fetchVacations() async {
    try {
      isLoading.value = true;
      final trainer = data.read('user');
      final trainerId = trainer != null ? trainer['trainer_id'] : null;

      final response = await crud
          .getRequest('${AppLinks.showVacations}?trainer_id=$trainerId');

      if (response != null &&
          response['status'] == 'success' &&
          response['data'] != null) {
        vacations.value = response['data'];
      } else {
        errorMessage.value = 'حدث خطأ أثناء تحميل الإجازات';
      }
    } catch (e) {
      errorMessage.value = 'فشل الاتصال بالخادم';
    } finally {
      isLoading.value = false;
    }
  }
}
