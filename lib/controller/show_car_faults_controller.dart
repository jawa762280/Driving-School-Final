import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';

class ShowCarFaultsController extends GetxController {
  List faults = [];
  Crud crud = Crud();

  showFaults() async {
    var response = await crud.getRequest(AppLinks.carFaults);
    faults.addAll(response['data']);
    update();
  }

  @override
  void onInit() {
    showFaults();
    super.onInit();
  }
}
