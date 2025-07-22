import 'package:driving_school/controller/cars_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/widget/car_card_read_only.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllCarsScreen extends StatefulWidget {
  const AllCarsScreen({super.key});

  @override
  State<AllCarsScreen> createState() => _AllCarsScreenState();
}

class _AllCarsScreenState extends State<AllCarsScreen> {
  final controller = Get.put(CarsController());
  int _selectedIndex = 0;

  static const List<String> _tabs = ['الكل', 'عادية', 'احتياجات'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('جميع السيارات'),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Loading();
          }

          // Filter cars based on selected index
          final filteredCars = controller.cars.where((car) {
            switch (_selectedIndex) {
              case 1:
                return !car.isForSpecialNeeds;
              case 2:
                return car.isForSpecialNeeds;
              case 0:
              default:
                return true;
            }
          }).toList();

          return Column(
            children: [
              SizedBox(height: 12.h),
              ToggleButtons(
                isSelected:
                    List.generate(_tabs.length, (i) => i == _selectedIndex),
                onPressed: (index) {
                  setState(() => _selectedIndex = index);
                },
                borderRadius: BorderRadius.circular(20.r),
                selectedColor: Colors.white,
                fillColor: AppColors.primaryColor,
                color: AppColors.primaryColor,
                borderColor: AppColors.primaryColor.withOpacity(0.4),
                selectedBorderColor: AppColors.primaryColor,
                children: _tabs.map((title) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: filteredCars.isEmpty
                    ? const Center(child: Text('لا توجد سيارات مطابقة حالياً'))
                    : GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: filteredCars.length,
                        itemBuilder: (context, index) {
                          return CarCardReadonly(car: filteredCars[index]);
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
