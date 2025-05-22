import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/data/model/car_model.dart';
import 'package:get/get.dart';

class CarsController extends GetxController {
  var isLoading = true.obs;
  var cars = <CarModel>[].obs;

  final Crud crud = Crud();

  @override
  void onInit() {
    super.onInit();
    fetchCars();
  }

  void fetchCars() async {
    try {
      isLoading(true);

      // استدعاء API للحصول على بيانات السيارات
      final response = await crud.getRequest(AppLinks.cars); 
      // استبدل AppLinks.carsEndpoint برابط API الصحيح الخاص بالسيارات

      if (response != null && response['status'] == 'success') {
        cars.value = (response['data'] as List)
            .map((json) => CarModel.fromJson(json))
            .toList();
      } else {
        cars.clear(); // لو في خطأ أو بيانات فارغة
      }
    } catch (e) {
      cars.clear();
    } finally {
      isLoading(false);
    }
  }
}
