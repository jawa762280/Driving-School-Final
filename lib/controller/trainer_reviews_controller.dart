import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';

class TrainerReviewsController extends GetxController {
  List reviews = [];
  Crud crud = Crud();
  String id = '';

  getReviews() async {
    var response =
        await crud.getRequest('${AppLinks.init}/trainer/$id/reviews');
    if (response[0].isNotEmpty) {
      reviews.addAll(response);
    }

    update();
  }

  @override
  void onInit() {
    id = Get.arguments['trainer_id'].toString();
    getReviews();
    super.onInit();
  }
}
