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
    try {
      final response = await crud.getRequest(
        '${AppLinks.searchTrainers}?first_name=$query',
      );

      if (response != null && response['status'] == 'success') {
        // ✅ توجد نتائج
        allInstructors.value = response['data'];
        filteredInstructors.value = response['data'];
        print("✅ تم جلب ${response['data'].length} مدرب");
      } else if (response != null && response['status'] == 'fail') {
        // ⚠️ لم يتم العثور على مدربين – بدون خطأ في السيرفر
        allInstructors.clear();
        filteredInstructors.clear();

        // ✅ عرض Snackbar مرة واحدة فقط
        if (query.trim().isNotEmpty) {
          Get.snackbar("لا يوجد نتائج", "لم يتم العثور على مدربين بهذا الاسم");
        }
      } else {
        Get.snackbar("خطأ", "فشل في جلب البيانات");
      }
    } catch (e) {
      Get.snackbar("خطأ", "تعذر الاتصال بالخادم");
    }
  }

  void search(String query) {
    fetchInstructors(query: query);
  }
}
