import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:get/get.dart';

class MySearchController extends GetxController {
  Crud crud = Get.put(Crud());

  RxList<dynamic> allInstructors = [].obs;
  RxList<dynamic> filteredInstructors = [].obs;
  RxString currentUserRole = ''.obs;
  List reviews = [];

  @override
  void onInit() {
    super.onInit();
    currentUserRole.value = data.read('role') ?? 'student';
    fetchInstructors();
  }

  Future<void> fetchInstructors({String query = ''}) async {
    try {
      final response = await crud.getRequest(
        '${AppLinks.searchTrainers}?first_name=$query',
      );

      if (response != null && response['status'] == 'success') {
        allInstructors.value = response['data'];
        filteredInstructors.value = response['data'];
        getReviews();
      } else if (response != null && response['status'] == 'fail') {
        allInstructors.clear();
        filteredInstructors.clear();

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

  getReviews() async {
    for (var i = 0; i < filteredInstructors.length; i++) {
      var trainer = filteredInstructors[i];

      var response = await crud.getRequest(
          'http://192.168.1.107:8000/api/trainer/${trainer['trainer_id']}/reviews');

      double totalRating = 0;
      int ratingCount = 0;

      if (response is List) {
        // Eğer iç içe liste geldiyse düzleştir
        var flatList = response.expand((e) {
          if (e is List) {
            return e;
          } else {
            return [e];
          }
        }).toList();

        for (var inner in flatList) {
          if (inner is Map && inner['rating'] != null) {
            totalRating += double.tryParse(inner['rating'].toString()) ?? 0;
            ratingCount++;
          }
        }
      }

      double avgRating = ratingCount > 0 ? totalRating / ratingCount : 0;

      // Eğitmene reviews ve avg_rating ekle
      filteredInstructors[i] = {
        ...trainer,
        'reviews': response,
        'avg_rating': avgRating
      };
    }

    update();
  }
}
