import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';

class BookingsSessionsController extends GetxController {
  final Crud crud = Crud();

  var sessions = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainerSessions();
  }

  Future<void> fetchTrainerSessions() async {
    isLoading.value = true;
    error.value = '';

    final response =
        await crud.getRequest(AppLinks.bookingSessions); // تأكد إن الرابط صحيح

    isLoading.value = false;

    if (response != null && response['data'] != null) {
      sessions.value = response['data'];
    } else {
      error.value = response?['message'] ?? 'حدث خطأ أثناء جلب الجلسات';
    }
  }
}
