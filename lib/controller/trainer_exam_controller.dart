import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';
import 'package:driving_school/data/model/exam_model.dart';
import 'package:driving_school/core/constant/app_api.dart';

class TrainerExamController extends GetxController {
  Crud crud = Crud();

  var isLoading = false.obs;
  var exams = <ExamModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainerExams();
  }

  Future<void> fetchTrainerExams() async {
    isLoading.value = true;
    errorMessage.value = '';

    var response = await crud.getRequest(AppLinks.showTrainerExam);

    if (response is List) {
      try {
        exams.value = response.map((e) => ExamModel.fromJson(e)).toList();
      } catch (e) {
        errorMessage.value = 'خطأ في معالجة البيانات';
        // ignore: avoid_print
        print('❌ JSON parse error: $e');
      }
    } else if (response is Map) {
      if (response['statusCode'] == 401) {
        errorMessage.value = 'انتهت الجلسة، يرجى إعادة تسجيل الدخول';
      } else if (response.containsKey('error')) {
        errorMessage.value = 'فشل الاتصال بالخادم: ${response['error']}';
      } else {
        errorMessage.value = 'فشل في جلب البيانات';
      }
    } else {
      errorMessage.value = 'استجابة غير متوقعة من الخادم';
    }

    isLoading.value = false;
  }
}
