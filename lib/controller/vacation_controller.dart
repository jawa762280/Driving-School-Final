import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/main.dart';
import 'package:table_calendar/table_calendar.dart';

class VacationController extends GetxController {
  final Crud crud = Crud();
  var success = false.obs;
  var selectedDates = <String>[].obs;
  var reason = ''.obs;
  var isSubmitting = false.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;



  void toggleDate(String date) {
    if (selectedDates.contains(date)) {
      selectedDates.remove(date);
    } else {
      selectedDates.add(date);
    }
  }
  var availableSessionDates = <String>[].obs;

void setAvailableDatesFromSessions(List<dynamic> sessions) {
  availableSessionDates.clear();
  for (var day in sessions) {
    if ((day['sessions'] as List).isNotEmpty) {
      availableSessionDates.add(day['date']);
    }
  }
}

  Future<void> submitVacation() async {
    if (selectedDates.isEmpty || reason.isEmpty) {
      Get.snackbar("تنبيه", "يرجى اختيار تواريخ وإدخال سبب الإجازة");
      return;
    }

    try {
      isSubmitting.value = true;

      final trainer = data.read('user')['trainer'];
      final trainerId = trainer != null ? trainer['id'] : null;

      final response = await crud.postRequest(AppLinks.trainerVacation, {
        "trainer_id": trainerId,
        "exception_dates": selectedDates,
        "reason": reason.value
      });

      if (response != null &&
          response['status'] != false &&
          response['message'] != null) {
        Get.snackbar("نجاح", response['message']);
        selectedDates.clear();
        reason.value = '';
        success.value = true;
      } else if (response != null && response['status'] == false) {
        // هنا عندنا خطأ من السيرفر (مثلاً 422)
        String errorMessage = response['message'] ?? 'حدث خطأ في البيانات';
        Get.snackbar("خطأ", errorMessage);
        success.value = false;
      } else {
        Get.snackbar("خطأ", "فشل تسجيل الإجازة");
        success.value = false;
      }
    } catch (e) {
      Get.snackbar("خطأ", "تعذر الاتصال بالخادم");
    } finally {
      isSubmitting.value = false;
    }
  }
}
