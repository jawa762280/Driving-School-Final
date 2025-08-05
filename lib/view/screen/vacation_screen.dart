import 'package:driving_school/controller/training_sessions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/vacation_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class VacationScreen extends StatelessWidget {
  final sessionController = Get.put(TrainingSessionsController());
  final vacationController = Get.put(VacationController());

  VacationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("طلب إجازة", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white), 

        backgroundColor: AppColors.primaryColor,
      ),
      body: Obx(() {
        if (sessionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (sessionController.errorMessage.isNotEmpty) {
          return Center(child: Text(sessionController.errorMessage.value));
        }

        if (vacationController.availableSessionDates.isEmpty) {
          vacationController
              .setAvailableDatesFromSessions(sessionController.sessionsData);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "اختر الأيام التي تريد الإجازة فيها:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).toInt()),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Obx(() {
                  return TableCalendar(
                    calendarFormat: vacationController.calendarFormat.value,
                    onFormatChanged: (format) {
                      vacationController.calendarFormat.value = format;
                    },
                    locale: 'ar',
                    focusedDay: vacationController.focusedDay.value,
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectedDayPredicate: (day) => vacationController
                        .selectedDates
                        .contains(DateFormat('yyyy-MM-dd').format(day)),
                    onDaySelected: (selectedDay, focusedDay) {
                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(selectedDay);
                      final hasSessions = vacationController
                          .availableSessionDates
                          .contains(formattedDate);

                      if (!hasSessions) {
                        Get.snackbar("تنبيه", "لا توجد جلسات في هذا اليوم");
                        return;
                      }

                      vacationController.toggleDate(formattedDate);
                      vacationController.focusedDay.value = focusedDay;
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(day);
                        final hasSessions = vacationController
                            .availableSessionDates
                            .contains(formattedDate);

                        if (hasSessions) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${day.day}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        }
                        return null;
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  onChanged: (val) => vacationController.reason.value = val,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "سبب الإجازة...",
                    border: InputBorder.none,
                    icon: Icon(Icons.edit_note),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: vacationController.isSubmitting.value
                        ? null
                        : () async {
                            await vacationController.submitVacation();
                            if (vacationController.success.value) {
                              // ignore: use_build_context_synchronously
                              showSuccessDialog(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          vacationController.isSubmitting.value
                              ? "جارٍ الإرسال..."
                              : "إرسال طلب الإجازة",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        vacationController.isSubmitting.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send, color: Colors.white),
                      ],
                    ),
                  )),
            ],
          ),
        );
      }),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height: 280,
          child: Column(
            children: [
              Lottie.asset('assets/lottie/success.json',
                  height: 150, repeat: false),
              const Text("تم تقديم الإجازة بنجاح!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              TextButton(
                child: const Text("حسناً"),
                onPressed: () => Get.back(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
