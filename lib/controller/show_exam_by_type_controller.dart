import 'package:driving_school/data/model/display_exam_model.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import '../../../core/constant/app_api.dart';

class ShowExamByTypeController extends GetxController {
  final Crud crud = Crud();
  var isLoading = false.obs;
  Rx<DisplayExam?> exam = Rx<DisplayExam?>(null);
  RxString selectedType = ''.obs;

  Future<void> fetchExamByType() async {
    final type = selectedType.value;
    if (type.isEmpty) {
      Get.snackbar('تحذير', 'يرجى اختيار نوع الامتحان أولاً');
      return;
    }

    isLoading.value = true;
    exam.value = null;

    final response = await crud.getRequest('${AppLinks.showExamByType}/$type');

    if (response != null &&
        response['exam'] != null &&
        response['exam']['questions'] != null) {
      exam.value = DisplayExam.fromJson(response['exam']);
    } else {
      Get.snackbar('خطأ', 'فشل تحميل الأسئلة من السيرفر');
    }

    isLoading.value = false;
  }
}