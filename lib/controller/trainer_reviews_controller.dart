import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';

class TrainerReviewsController extends GetxController {
  RxList reviews = <dynamic>[].obs;
  Crud crud = Crud();
  String id = '';
  RxBool isLoading = false.obs;
  RxBool hasReview = false.obs;

  getReviews() async {
    isLoading.value = true;
    var response =
        await crud.getRequest('${AppLinks.init}/trainer/$id/reviews');

    // ignore: avoid_print
    print('Full response: $response');
    // ignore: avoid_print
    print('Data part: ${response['data']}');

    var data = response['data'];
    hasReview.value = response['has_review'] == true;

    reviews.clear();

    if (data is List && data.isNotEmpty) {
      List cleanedReviews =
          data.where((e) => e is Map && e.isNotEmpty).toList();
      // ignore: avoid_print
      print('Cleaned reviews: $cleanedReviews');
      reviews.addAll(cleanedReviews);
    } else {
      // ignore: avoid_print
      print('Data is empty or not a list');
    }

    isLoading.value = false;
  }

  @override
  void onInit() {
    id = Get.arguments['trainer_id'].toString();
    getReviews();
    super.onInit();
  }
}
