import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';

class PracticalExamController extends GetxController {
  Crud crud = Crud();

  RxBool isLoading = false.obs;
  RxList exams = [].obs;

  getMyPracticalExams() async {
    isLoading.value = true;
    exams.clear();

    var response = await crud.getRequest(AppLinks.practicalExamMy);

    if (response['success'] == true) {
      exams.addAll(response['data']['data']);
    }

    isLoading.value = false;
  }

  @override
  void onInit() {
    getMyPracticalExams();
    super.onInit();
  }
}
