import 'package:driving_school/controller/cars_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/widget/car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum CarFilter { all, normal, special }

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CarsController());
    final filter = Rx<CarFilter>(CarFilter.all); // ⬅️ متغير للتصفية

    return Scaffold(
      appBar: AppBar(
        title: const Text("السيارات المتوفرة"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 🔍 فلترة السيارات حسب الاختيار
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FilterButton(
                    title: "الكل",
                    icon: Icons.view_list,
                    selected: filter.value == CarFilter.all,
                    onTap: () => filter.value = CarFilter.all,
                  ),
                  _FilterButton(
                    title: "عادية",
                    icon: Icons.directions_car,
                    selected: filter.value == CarFilter.normal,
                    onTap: () => filter.value = CarFilter.normal,
                  ),
                  _FilterButton(
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
                  ? Center(child: Text("لا توجد سيارات مطابقة"))
                  : ListView.separated(
                      padding: EdgeInsets.all(16.w),
                      itemCount: filteredCars.length,
                      itemBuilder: (context, index) =>
                          CarCard(car: filteredCars[index]),
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor.withAlpha((0.1 * 255).toInt())
              : Colors.white,
          border: Border.all(
              color: selected ? AppColors.primaryColor : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18.sp,
                color: selected ? AppColors.primaryColor : Colors.grey),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
