import 'package:driving_school/controller/search_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/view/widget/containersearch.dart';
import 'package:driving_school/view/widget/customsearchbar.dart';
import 'package:driving_school/view/widget/my_appbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MySearchController controller = Get.put(MySearchController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyAppBar(
                  image: Image.asset(AppImages.appPhoto),
                  widget: Text(
                    "البحث",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 40.h),
                CustomSearchBar(
                  onChanged: (value) {
                    controller.search(value);
                  },
                ),
                SizedBox(height: 30.h),
                Expanded(
                  child: Obx(() => ListView.builder(
                        itemCount: controller.filteredInstructors.length,
                        itemBuilder: (context, index) {
                          final instructor =
                              controller.filteredInstructors[index];
                          return Column(
                            children: [
                              ContainerSearch(
                                image: AppImages.appPhoto,
                                name:
                                    '${instructor['first_name']} ${instructor['last_name']}',
                                email: instructor['email'] ?? '',
                                adressText: "العنوان",
                                adress: instructor['address'] ?? '',
                                phoneText: "رقم الهاتف",
                                phone: instructor['phone'] ?? '',
                                birthdayText: "تاريخ الميلاد",
                                birthday: instructor['birth_date'] ?? '',
                              ),
                              SizedBox(height: 15),
                            ],
                          );
                        },
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
