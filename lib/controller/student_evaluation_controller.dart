import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/data/model/evaluation_student_model.dart';
import 'package:get/get.dart';

class StudentEvaluationController extends GetxController {
  var isLoading = false.obs;
    final Crud crud = Crud();  // كلاس crud

  var evaluations = <EvaluationStudentModel>[].obs;
  var passedAll = false.obs;
  var finalStatus = ''.obs;



  @override
  void onInit() {
    super.onInit();
    fetchEvaluation();
  }

  Future<void> fetchEvaluation() async {
    try {
      isLoading.value = true;

      final response = await crud.getRequest(AppLinks.evaluationStuent);

      // نفترض أن response هو Map مفكك من JSON
      if (response != null && response['details'] != null) {
        final List<dynamic> details = response['details'];
        evaluations.value = details.map((e) => EvaluationStudentModel.fromJson(e)).toList();
        passedAll.value = response['passed_all'] ?? false;
        finalStatus.value = response['final_status'] ?? '';
      } else {
        Get.snackbar('خطأ', 'فشل تحميل النتائج');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل البيانات');
    } finally {
      isLoading.value = false;
    }
  }
}
