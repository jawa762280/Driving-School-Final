import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';

class ShowCarFaultsController extends GetxController {
  List faults = [];
  Crud crud = Crud();
  RxBool isLoading = false.obs;
  showFaults() async {
    isLoading.value = true;
    var response = await crud.getRequest(AppLinks.carFaults);
    faults.clear();
    faults.addAll(response['data']);
    isLoading.value = false;

    update();
  }

  @override
  void onInit() {
    showFaults();
    super.onInit();
  }
}
