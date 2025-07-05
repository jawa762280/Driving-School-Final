import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:get/get.dart';

class MyLicensesController extends GetxController {
  Crud crud = Crud();
  List myLicenses = [];
  List licenses = [];
  RxBool isLoading = false.obs;

  getMyLicense() async {
    isLoading.value = true;
    myLicenses.clear();

    var response = await crud.getRequest(AppLinks.licenseRequestsMy);
    if (response['success'] == true) {
      myLicenses.addAll(response['data']);
    }
    isLoading.value = false;

    update();
  }

  getLicense() async {
    var response = await crud.getRequest(AppLinks.licenses);
    if (response['success'] == true) {
      licenses.addAll(response['data']);
    }
    update();
  }

  @override
  void onInit() {
    myLicenses.clear();

    getMyLicense();
    super.onInit();
  }
}
