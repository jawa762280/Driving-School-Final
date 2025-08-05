import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/data/model/evaluation_student_model.dart';
import 'package:get/get.dart';

class StudentEvaluationController extends GetxController {
  var isLoading = false.obs;
  final Crud crud = Crud();
  late int studentId;
  var isCertificateGenerated = false.obs;
  var certificateUrl = ''.obs;

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

      if (response != null && response['details'] != null) {
        final List<dynamic> details = response['details'];
        evaluations.value =
            details.map((e) => EvaluationStudentModel.fromJson(e)).toList();
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

  Future<void> generateCertificate(int studentId) async {
    try {
      isLoading.value = true;

      final response =
          await crud.getRequest("${AppLinks.generateCertificate}/$studentId");

      if (response != null && response['certificate_url'] != null) {
        Get.snackbar('نجاح ✅', response['message']);

        String localPath = response['certificate_url'];

        String publicUrl = localPath.replaceAll('\\', '/').replaceAll(
            'C:/xampp/htdocs/DrivingSchoolSystem/storage/app/public',
            'http://192.168.1.107:8000/storage');

        // ignore: avoid_print
        print('رابط الشهادة بعد التحويل: "$publicUrl"');

        certificateUrl.value = publicUrl;
        isCertificateGenerated.value = true;
      } else {
        Get.snackbar('خطأ', 'فشل توليد الشهادة');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error generating certificate: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء توليد الشهادة');
    } finally {
      isLoading.value = false;
    }
  }
}
