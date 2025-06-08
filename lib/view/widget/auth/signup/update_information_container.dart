import 'dart:io';

import 'package:driving_school/controller/update_information_controller.dart';
import 'package:driving_school/main.dart';
import 'package:driving_school/view/widget/genderchip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart'; // استيراد الدالة
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateInformationContainer extends StatelessWidget {
  const UpdateInformationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateInformationController>(
      builder: (controller) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 12.w,
              offset: Offset(0, 4.w),
            ),
          ],
        ),
        child: Form(
          key: controller.formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  " تحديث المعلومات الشخصية ",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24.h),
              // الاسم الأول
              Text("الاسم",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(
                    val, 2, 30, "username"), // تعديل لاستخدام validInput
                mycontroller: controller.firstNameController,
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person,
                iconColor: AppColors.primaryColor,
                filled: true,
              ),

              // الاسم الأخير
              Text("الكنية",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(
                    val, 2, 30, "username"), // تعديل لاستخدام validInput
                mycontroller: controller.lastNameController,
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person_2_outlined,
                iconColor: AppColors.primaryColor,
                filled: true,
              ),
              SizedBox(height: 16.h),
              Text("البريد الالكتروني",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                mycontroller: controller.email,
                prefixIcon: Icons.email,
                iconColor: AppColors.primaryColor,
                filled: true,
                readOnly: true,
              ),
              SizedBox(height: 16.h),
              Text("كلمة المرور",
                  style: TextStyle(color: Colors.grey[800], fontSize: 12.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(val, 2, 30, "password"),
                mycontroller: controller.password,
                obscureText: controller.isShowPass,
                prefixIcon: Icons.visibility,
                keyboardType: TextInputType.text,
                iconColor: AppColors.primaryColor,
                filled: true,
              ),
              SizedBox(height: 16.h),
              // حقل تاريخ الميلاد
              Text("تاريخ الميلاد",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(val, 8, 10, "date_of_Birth"),
                mycontroller: controller.birthDateController,
                keyboardType: TextInputType.datetime,
                prefixIcon: Icons.calendar_today,
                iconColor: AppColors.primaryColor,
                filled: true,
                readOnly: true,
                onTapTextField: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat("yyyy-MM-dd").format(pickedDate);
                    controller.birthDateController.text = formattedDate;
                  }
                },
              ),
              SizedBox(height: 16.h),
              Text("رقم الهاتف",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(val, 10, 10, "phone_number"),
                mycontroller: controller.phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_android,
                iconColor: AppColors.primaryColor,
                errorText: controller.phoneError,
                filled: true,
              ),

              SizedBox(height: 16.h),
              Text("العنوان",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(
                    val, 3, 255, "address"), // تعديل لاستخدام validInput
                mycontroller: controller.addressController,
                keyboardType: TextInputType.text,
                prefixIcon: Icons.home,
                iconColor: AppColors.primaryColor,
                filled: true,
              ),

              SizedBox(height: 16.h),
              Text("الدور",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                ),
                value: controller.roleController.text.isNotEmpty
                    ? controller.roleController.text
                    : null,
                items: const [
                  DropdownMenuItem(value: 'student', child: Text('طالب')),
                  DropdownMenuItem(value: 'trainer', child: Text('مدرب')),
                  DropdownMenuItem(value: 'employee', child: Text('موظف')),
                ],
                onChanged: (controller.roleController.text == "student" ||
                        controller.roleController.text == "trainer")
                    ? null
                    : (val) {
                        controller.roleController.text = val!;
                        controller.update();
                      },
                validator: (value) =>
                    value == null || value.isEmpty ? 'يرجى اختيار الدور' : null,
                disabledHint: Text(
                  controller.roleController.text == 'student'
                      ? 'طالب'
                      : controller.roleController.text == 'trainer'
                          ? 'مدرب'
                          : controller.roleController.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 16.h),
              Text("الجنس",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),

              GetBuilder<UpdateInformationController>(
                builder: (controller) => Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children: [
                      GenderChip(
                          label: "ذكر",
                          icon: Icons.male,
                          value: "male",
                          selectedValue: controller.genderController.text,
                          onSelected: (val) {
                            controller.genderController.text = val;
                            controller.update();
                          }),
                      GenderChip(
                          label: "أنثى",
                          icon: Icons.female,
                          value: "female",
                          selectedValue: controller.genderController.text,
                          onSelected: (val) {
                            controller.genderController.text = val;
                            controller.update();
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              data.read('role') == 'trainer'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("رقم الرخصة",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 11.sp)),
                        SizedBox(height: 15.h),
                        MyTextformfield(
                          valid: (val) =>
                              validInput(val, 7, 255, "License Number"),
                          mycontroller: controller.licenseNumber,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.credit_card_outlined,
                          iconColor: AppColors.primaryColor,
                          filled: true,
                        ),
                        SizedBox(height: 16.h),
                        Text("تاريخ انتهاء الرخصة",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 11.sp)),
                        SizedBox(height: 15.h),
                        MyTextformfield(
                          valid: (val) =>
                              validInput(val, 8, 10, "date_of_expiry"),
                          mycontroller: controller.licenseExpiryDate,
                          keyboardType: TextInputType.datetime,
                          prefixIcon: Icons.calendar_today,
                          iconColor: AppColors.primaryColor,
                          filled: true,
                          readOnly: true,
                          onTapTextField: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(21000),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat("yyyy-MM-dd").format(pickedDate);
                              controller.licenseExpiryDate.text = formattedDate;
                            }
                          },
                        ),
                        // SizedBox(height: 16.h),
                        // Text("نوع التدريب",
                        //     style: TextStyle(
                        //         color: Colors.grey[800], fontSize: 11.sp)),
                        // SizedBox(height: 15.h),
                        // DropdownButtonFormField<String>(
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey[100],
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12.r),
                        //       borderSide: BorderSide.none,
                        //     ),
                        //     contentPadding: EdgeInsets.symmetric(
                        //         horizontal: 12.w, vertical: 14.h),
                        //   ),
                        //   value: controller.trainingType.text.isNotEmpty
                        //       ? controller.trainingType.text
                        //       : null,
                        //   items: const [
                        //     DropdownMenuItem(
                        //         value: 'normal', child: Text('عادي')),
                        //     DropdownMenuItem(
                        //         value: 'special_needs',
                        //         child: Text('ذوي الاحتياجات الخاصة')),
                        //   ],
                        //   onChanged: (val) {
                        //     controller.trainingType.text = val!;
                        //     controller.update();
                        //   },
                        //   validator: (value) => value == null || value.isEmpty
                        //       ? 'يرجى اختيار نوع التدريب'
                        //       : null,
                        // ),
                        SizedBox(height: 16.h),
                        Text("الخبرات ",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 11.sp)),
                        SizedBox(
                          height: 15.h,
                        ),
                        MyTextformfield(
                          valid: (val) => validInput(val, 2, 30,
                              "username"), // تعديل لاستخدام validInput
                          mycontroller: controller.experience,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.workspace_premium_outlined,
                          iconColor: AppColors.primaryColor,
                          filled: true,
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 15.h),

              InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    controller.imageFile = File(pickedFile.path);
                    controller.imageController.text = pickedFile.path;
                  }
                  controller.update();
                },
                child: Center(
                  child: Container(
                    height: 150.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(75.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75.r),
                      child: controller.imageFile != null
                          ? Image.file(
                              controller.imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : (controller.imageUrl != null &&
                                  controller.imageUrl!.isNotEmpty
                              ? Image.network(
                                  controller.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image,
                                        size: 50.sp, color: Colors.white),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'اضغط لاختيار\n صورة',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    ),
                                  ],
                                )),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              MyButton(
                onPressed: () {
                  controller.updateInformation();
                },
                text: "حفظ",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
