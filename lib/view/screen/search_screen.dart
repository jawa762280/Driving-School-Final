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
                  image: Image.asset(
                    AppImages.appPhoto,
                    fit: BoxFit.contain,
                  ),
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
                    child: Obx(() => RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchInstructors();
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredInstructors.length,
                          itemBuilder: (context, index) {
                            final instructor =
                                controller.filteredInstructors[index];
                            final double avgRating =
                                instructor['avg_rating'] ?? 0;

                            return Column(
                              children: [
                                ContainerSearch(
                                  image: instructor['image'] ?? '',
                                  name:
                                      '${instructor['first_name']} ${instructor['last_name']}',
                                  email: instructor['email'] ?? '',
                                  trainerId: instructor['trainer_id'],
                                  userRole: controller.currentUserRole.value,
                                  reviews: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ...List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < avgRating.round()
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                      SizedBox(width: 6),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          },
                        ))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}