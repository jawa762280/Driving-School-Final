import 'dart:io';

import 'package:driving_school/view/widget/genderchip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:driving_school/controller/sign_up_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart'; // استيراد الدالة
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
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
                  "تسجيل حساب",
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
              SizedBox(height: 16.h),
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
              // البريد الالكتروني
              Text("البريد الالكتروني",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(
                    val, 5, 50, "email"), // تعديل لاستخدام validInput
                mycontroller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                iconColor: AppColors.primaryColor,
                errorText: controller.emailError,
                filled: true,
              ),
              SizedBox(height: 16.h),
              // كلمة المرور
              Text("كلمة المرور",
                  style: TextStyle(color: Colors.grey[800], fontSize: 12.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(
                    val, 8, 50, "password"), // تعديل لاستخدام validInput
                mycontroller: controller.passController,
                obscureText: controller.isShowPass,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.visibility,
                iconColor: AppColors.primaryColor,
                onTapIcon: () => controller.showPass(),
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
                valid: (val) => validInput(
                    val, 10, 10, "phone_number"), // تعديل لاستخدام validInput
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
                ],
                onChanged: (val) {
                  controller.roleController.text = val!;
                  controller.update();
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'يرجى اختيار الدور' : null,
              ),
              SizedBox(height: 16.h),
              Text("الجنس",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),

              GetBuilder<SignUpController>(
                builder: (controller) => Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children: [
                      GenderChip(
                          label: "ذكر",
                          icon: Icons.male,
                          value: "Male",
                          selectedValue: controller.genderController.text,
                          onSelected: (val) {
                            controller.genderController.text = val;
                            controller.update();
                          }),
                      GenderChip(
                          label: "أنثى",
                          icon: Icons.female,
                          value: "Female",
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
              controller.roleController.text == 'trainer'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("رقم الرخصة",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 11.sp)),
                        SizedBox(height: 15.h),
                        MyTextformfield(
                          valid: (val) =>
                              validInput(val, 1, 6, "License Number"),
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
                        SizedBox(height: 16.h),
                        Text("نوع التدريب",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 11.sp)),
                        SizedBox(height: 15.h),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 14.h),
                          ),
                          value: controller.trainingType.text.isNotEmpty
                              ? controller.trainingType.text
                              : null,
                          items: const [
                            DropdownMenuItem(
                                value: 'normal', child: Text('عادي')),
                            DropdownMenuItem(
                                value: 'special_needs',
                                child: Text('ذوي الاحتياجات الخاصة')),
                          ],
                          onChanged: (val) {
                            controller.trainingType.text = val!;
                            controller.update();
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'يرجى اختيار نوع التدريب'
                              : null,
                        ),
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
              SizedBox(height: 25.h),
              Text("الصورة الشخصية",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  controller.update();
                  if (pickedFile != null) {
                    controller.imageFile = File(pickedFile
                        .path); // يجب إضافة imageFile داخل Controller كـ File?
                    controller.imageController.text = pickedFile.path;
                  }
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
                    child: controller.imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image,
                                  size: 50.sp, color: Colors.white),
                              SizedBox(height: 10.h),
                              Text(
                                textAlign: TextAlign.center,
                                'اضغط لاختيار\n صورة',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              controller.imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              if (controller.roleController.text == 'student') ...[
                SizedBox(height: 16.h),
                Text("ذوي الاحتياجات الخاصة",
                    style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
                SizedBox(height: 8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: AppColors.primaryColor,
                        value: controller.isLeftHandDisabled,
                        onChanged: (val) {
                          controller.isLeftHandDisabled = val!;
                          controller.update();
                        },
                      ),
                      Expanded(
                        child: Text(
                          "هل أنت من ذوي الإعاقة باليد اليسرى؟",
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 8.w),
                  child: Text(
                    "نقبل فقط حالات الإعاقة باليد اليسرى حصرا",
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  ),
                ),
              ],

              SizedBox(height: 30.h),
              MyButton(
                onPressed: () {
                  controller.signUp();
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
