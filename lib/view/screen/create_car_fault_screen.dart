import 'package:driving_school/controller/create_car_fault_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/screen/cars_screen.dart';
import 'package:driving_school/view/widget/filter_button.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateCarFault extends StatelessWidget {
  const CreateCarFault({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CreateCarFaultController(),
        builder: (controller) {
          final filter = Rx<CarFilter>(CarFilter.all);

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F8),
            appBar: AppBar(
              title: const Text(
                "إبلاغ عطل سيارة",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 2,
            ),
            body: Obx(() {
              final filteredCars = controller.cars.where((car) {
                switch (filter.value) {
                  case CarFilter.normal:
                    return !car.isForSpecialNeeds;
                  case CarFilter.special:
                    return car.isForSpecialNeeds;
                  case CarFilter.all:
                    return true;
                }
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilterButton(
                          title: "الكل",
                          icon: Icons.view_list,
                          selected: filter.value == CarFilter.all,
                          onTap: () => filter.value = CarFilter.all,
                        ),
                        FilterButton(
                          title: "عادية",
                          icon: Icons.directions_car,
                          selected: filter.value == CarFilter.normal,
                          onTap: () => filter.value = CarFilter.normal,
                        ),
                        FilterButton(
                          title: "احتياجات",
                          icon: Icons.accessible,
                          selected: filter.value == CarFilter.special,
                          onTap: () => filter.value = CarFilter.special,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filteredCars.isEmpty
                        ? const Center(child: Text("لا توجد سيارات مطابقة"))
                        : ListView.separated(
                            padding: EdgeInsets.all(16.w),
                            itemCount: filteredCars.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final car = filteredCars[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.directions_car, size: 28, color: AppColors.primaryColor),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              car.model,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            car.isForSpecialNeeds ? "احتياجات خاصة" : "عادية",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              showFaultDialog(context, controller, car.id.toString());
                                            },
                                            icon: const Icon(Icons.warning_amber_outlined),
                                            label: const Text("إبلاغ عطل"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.lightGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }),
          );
        });
  }
}


void showFaultDialog(BuildContext context, CreateCarFaultController controller, id) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: Text(
        'تفاصيل العطل',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("يرجى إدخال وصف واضح ومحدد للمشكلة."),
          SizedBox(height: 10),
          TextFormField(
            controller: controller.faultController,
            maxLines: 5,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'مثال: المكابح لا تعمل بشكل جيد...',
              hintTextDirection: TextDirection.rtl,
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Obx(() => Center(
              child: controller.isLoading.value
                  ?  CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )
                  : MyButton(
                      onPressed: () => controller.sendFault(id),
                      text: 'إرسال البلاغ',
                      icon: Icons.send,
                    ),
            ))
      ],
    ),
  );
}

