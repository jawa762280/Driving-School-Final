import 'package:driving_school/controller/request_licence_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RequestLicenceScreen extends StatelessWidget {
  const RequestLicenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestLicenceController>(
        init: RequestLicenceController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: const Color(0xFFF2F4F7),
            appBar: AppBar(
              title: const Text(
                "طلب رخصة قيادة",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              elevation: 2,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  tooltip: 'تحديث',
                  onPressed: () {
                    controller.refreshData();
                  },
                ),
              ],
            ),
            body: Obx(() {
              if (controller.isPageLoading.value) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.green));
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitleWithIcon("نوع الرخصة", Icons.car_repair),
                    const SizedBox(height: 10),
                    buildDropdown(
                      value: controller.licenceCodeController.text.isNotEmpty
                          ? controller.licenceCodeController.text
                          : null,
                      hint: "اختر نوع الرخصة",
                      icon: Icons.arrow_drop_down_circle_outlined,
                      items: controller.licenceCode
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem(
                                    value: e['type'].toString(),
                                    child: Text(e['name'].toString()),
                                  ))
                          .toList(),
                      onChanged: (val) {
                        controller.licenceCodeController.text = val!;
                        controller.update();
                        controller.getLicences();
                      },
                    ),
                    SizedBox(height: 25.h),
                    buildTitleWithIcon("نوع الطلب", Icons.loop),
                    const SizedBox(height: 10),
                    buildDropdown(
                      value: controller.licenceTypeController.text.isNotEmpty
                          ? controller.licenceTypeController.text
                          : null,
                      hint: "اختر نوع الطلب",
                      icon: Icons.arrow_drop_down_circle_outlined,
                      items: const [
                        DropdownMenuItem(value: 'new', child: Text('لأول مرة')),
                        DropdownMenuItem(
                            value: 'renewal', child: Text('تجديد')),
                        DropdownMenuItem(
                            value: 'replacement', child: Text('بدل ضائع')),
                      ],
                      onChanged: (val) {
                        controller.licenceTypeController.text = val!;
                        controller.update();
                      },
                    ),
                    SizedBox(height: 35.h),
                    if (controller.licenceTypes.isNotEmpty)
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 8,
                          shadowColor: AppColors.primaryColor
                              .withAlpha((0.3 * 255).toInt()),
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "معلومات الرخصة",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Icon(Icons.monetization_on,
                                        color: Colors.green.shade700),
                                    const SizedBox(width: 8),
                                    Text(
                                      "السعر: ${controller.licenceTypes[0]['registration_fee']} ليرة سورية",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Icon(Icons.cake,
                                        color: Colors.green.shade700),
                                    const SizedBox(width: 8),
                                    Text(
                                      "العمر الأدنى: ${controller.licenceTypes[0]['min_age']} سنة",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25.h),
                                Text(
                                  "المستندات المطلوبة:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                                SizedBox(height: 12.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller
                                      .licenceTypes[0]['required_documents']
                                      .length,
                                  itemBuilder: (context, i) {
                                    final isUploaded = i == 0
                                        ? controller.file1.value != null
                                        : controller.file2.value != null;
                                    final displayedName = isUploaded
                                        ? (i == 0
                                            ? controller.file1.value!.path
                                                .split('/')
                                                .last
                                            : controller.file2.value!.path
                                                .split('/')
                                                .last)
                                        : controller.licenceTypes[0]
                                            ['required_documents'][i];

                                    return InkWell(
                                      onTap: () => controller.pickFile(i),
                                      borderRadius: BorderRadius.circular(14),
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 6.h),
                                        padding: EdgeInsets.all(14.w),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withAlpha(
                                                  (0.1 * 255).toInt()),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.file_present,
                                                color: AppColors.primaryColor),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Text(
                                                displayedName,
                                                style:
                                                    TextStyle(fontSize: 13.sp),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Icon(Icons.upload_file,
                                                color: Colors.black45),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 30.h),
                                Obx(() {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14.h),
                                      backgroundColor: AppColors.primaryColor,
                                      minimumSize: Size(double.infinity, 54.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 6,
                                    ),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () => controller.sendRequest(),
                                    child: Row(
                                      textDirection: TextDirection.ltr,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (controller.isLoading.value)
                                          SizedBox(
                                            width: 20.w,
                                            height: 20.w,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        else
                                          const Icon(
                                            Icons.send,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        const SizedBox(width: 8),
                                        Text(
                                          controller.isLoading.value
                                              ? "جاري الإرسال..."
                                              : "إرسال الطلب",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          );
        });
  }

  Widget buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: Icon(icon, color: AppColors.primaryColor),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget buildTitleWithIcon(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 24.sp),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
