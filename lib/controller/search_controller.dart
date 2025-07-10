import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearchController extends GetxController {
  Crud crud = Get.put(Crud());
  final studentId = int.tryParse(data.read('id').toString());

  double rating = 3;
  TextEditingController comment = TextEditingController();
  var isLoading = false.obs;

  RxList<dynamic> allInstructors = [].obs;
  RxList<dynamic> filteredInstructors = [].obs;
  RxString currentUserRole = ''.obs;
  List reviews = [];

  @override
  void onInit() {
    super.onInit();
    currentUserRole.value = data.read('role') ?? 'student';
    print("👤 Loaded studentId: $studentId");

    if (studentId == null) {
      return;
    }

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
        '${AppLinks.init}/trainer/${trainer['trainer_id']}/reviews',
      );

      double totalRating = 0;
      int ratingCount = 0;
      bool hasReview = false;

      if (response != null && response['data'] is List) {
List<Map<String, dynamic>> flatReviews = extractReviews(response['data']);

        for (var item in response['data']) {
          if (item is Map<String, dynamic>) {
            flatReviews.add(item);
          } else if (item is List) {
            for (var subItem in item) {
              if (subItem is Map<String, dynamic>) {
                flatReviews.add(subItem);
              }
            }
          }
        }

        print(
            "👤 Checking if student $studentId has rated trainer ${trainer['trainer_id']}");

        for (var review in flatReviews) {
          print(
              "🔎 Review student_id: ${review['student_id']} - rating: ${review['rating']}");

          if (review['rating'] != null) {
            totalRating += double.tryParse(review['rating'].toString()) ?? 0;
            ratingCount++;

            if (review['student_id'].toString() == studentId.toString()) {
              hasReview = true;
              print(
                  "✅ Student $studentId has reviewed trainer ${trainer['trainer_id']}");
            }
          }
        }

        double avgRating = ratingCount > 0 ? totalRating / ratingCount : 0;

        filteredInstructors[i] = {
          ...trainer,
          'reviews': flatReviews,
          'avg_rating': avgRating,
          'has_review': hasReview,
        };
      } else {
        filteredInstructors[i] = {
          ...trainer,
          'reviews': [],
          'avg_rating': 0.0,
          'has_review': false,
        };
      }
    }

    update();
  }

 sendFeedbackStudent(int trainerId) async {
  isLoading.value = true;
  try {
    var response = await crud.postRequest(AppLinks.trainerReviews, {
      'trainer_id': trainerId,
      'comment': comment.text,
      'rating': rating,
    });

    print('MyResponse $response');

    if (response['status'] == true) {
      await updateTrainerReview(trainerId);

      Get.snackbar(
        "تم التقييم بنجاح",
        "شكراً لك على تقييمك للمدرب.",
        colorText: Colors.black,
        duration: Duration(seconds: 2),
      );

      Get.back(); 

      // إعادة تعيين الحقول (اختياري)
      comment.clear();
      rating = 3;
      update();
    } else {
      Get.snackbar(
        "تنبيه",
        "لا يمكنك تقييم هذا المدرب لأنك لم تكمل جلسة تدريبية معه.",
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
    }
  } catch (e) {
    Get.snackbar("خطأ", "حدث خطأ أثناء إرسال التقييم");
  } finally {
    isLoading.value = false;
    update();
  }
}


  Future<void> updateTrainerReview(int trainerId) async {
  int index = filteredInstructors.indexWhere((e) => e['trainer_id'] == trainerId);
  if (index == -1) return;

  final response = await crud.getRequest(
    '${AppLinks.init}/trainer/$trainerId/reviews',
  );

  double totalRating = 0;
  int ratingCount = 0;
  bool hasReview = false;
List<Map<String, dynamic>> flatReviews = extractReviews(response['data']);

  if (response != null && response['data'] is List) {
    for (var item in response['data']) {
      if (item is Map<String, dynamic>) {
        flatReviews.add(item);
      } else if (item is List) {
        for (var subItem in item) {
          if (subItem is Map<String, dynamic>) {
            flatReviews.add(subItem);
          }
        }
      }
    }

    for (var review in flatReviews) {
      if (review['rating'] != null) {
        totalRating += double.tryParse(review['rating'].toString()) ?? 0;
        ratingCount++;

        if (review['student_id'].toString() == studentId.toString()) {
          hasReview = true;
        }
      }
    }
  }

  double avgRating = ratingCount > 0 ? totalRating / ratingCount : 0;

  filteredInstructors[index] = {
    ...filteredInstructors[index],
    'reviews': flatReviews,
    'avg_rating': avgRating,
    'has_review': hasReview,
  };

  update();
}
List<Map<String, dynamic>> extractReviews(dynamic rawData) {
  List<Map<String, dynamic>> reviews = [];

  if (rawData is List) {
    for (var item in rawData) {
      if (item is Map<String, dynamic>) {
        reviews.add(item);
      } else if (item is List) {
        for (var subItem in item) {
          if (subItem is Map<String, dynamic>) {
            reviews.add(subItem);
          }
        }
      }
    }
  } else if (rawData is Map<String, dynamic>) {
    reviews.add(rawData);
  }

  return reviews;
}

}
