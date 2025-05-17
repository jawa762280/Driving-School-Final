import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';

class MySearchController extends GetxController {
  Crud crud = Get.put(Crud());

  RxList<dynamic> allInstructors = [].obs;
  RxList<dynamic> filteredInstructors = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInstructors();
  }

  void fetchInstructors({String query = ''}) async {
    // ignore: avoid_print
    print("🔍 البحث عن: $query");

    try {
      final response = await crud.getRequest(
        '${AppLinks.searchTrainers}?first_name=$query',
      );

      if (response != null && response['data'] != null) {
        allInstructors.value = response['data'];
        filteredInstructors.value = response['data'];
        // ignore: avoid_print
        print("✅ تم جلب ${response['data'].length} مدرب");
      } else {
        // ignore: avoid_print
        print("❌ فشل في جلب البيانات: $response");
        Get.snackbar("خطأ", "فشل في جلب البيانات");
      }
    } catch (e) {
      // ignore: avoid_print
      print("🚨 استثناء أثناء الطلب: $e");
      Get.snackbar("خطأ", "تعذر الاتصال بالخادم");
    }
  }

  void search(String query) {
    fetchInstructors(query: query);
  }
}
