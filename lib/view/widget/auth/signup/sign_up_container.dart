// import 'dart:io';

// import 'package:driving_school/view/widget/genderchip.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:driving_school/controller/sign_up_controller.dart';
// import 'package:driving_school/core/constant/appcolors.dart';
// import 'package:driving_school/core/functions/validinput.dart';
// import 'package:driving_school/view/widget/my_button.dart';
// import 'package:driving_school/view/widget/my_textformfield.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class SignUpContainer extends StatelessWidget {
//   const SignUpContainer({super.key, required this.controller});
//   final SignUpController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24.w),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withAlpha((0.05 * 255).toInt()),
//             blurRadius: 12.w,
//             offset: Offset(0, 4.w),
//           ),
//         ],
//       ),
//       child: Form(
//         key: controller.formState,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Center(
//               child: Text(
//                 "تسجيل حساب",
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 24.h),
//             // الاسم الأول
//             Text("الاسم",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
//             SizedBox(height: 15.h),
//             MyTextformfield(
//               valid: (val) => validInput(val, 3, 30, "username"),
//               mycontroller: controller.firstNameController,
//               keyboardType: TextInputType.name,
//               prefixIcon: Icons.person,
//               iconColor: AppColors.primaryColor,
//               filled: true,
//             ),
//             SizedBox(height: 16.h),
//             // الاسم الأخير
//             Text("الكنية",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
//             SizedBox(height: 15.h),
//             MyTextformfield(
//               valid: (val) => validInput(val, 3, 30, "username"),
//               mycontroller: controller.lastNameController,
//               keyboardType: TextInputType.name,
//               prefixIcon: Icons.person_2_outlined,
//               iconColor: AppColors.primaryColor,
//               filled: true,
//             ),
//             SizedBox(height: 16.h),
//             // البريد الالكتروني
//             Text("البريد الالكتروني",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
//             SizedBox(height: 15.h),
//             MyTextformfield(
//               valid: (val) => validInput(val, 4, 50, "email"),
//               mycontroller: controller.emailController,
//               keyboardType: TextInputType.emailAddress,
//               prefixIcon: Icons.email,
//               iconColor: AppColors.primaryColor,
//               filled: true,
//             ),
//             SizedBox(height: 16.h),
//             // كلمة المرور
//             Text("كلمة المرور",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 12.sp)),
//             SizedBox(height: 15.h),
//             MyTextformfield(
//               valid: (val) => validInput(val, 8, 50, "password"),
//               mycontroller: controller.passController,
//               obscureText: controller.isShowPass,
//               keyboardType: TextInputType.visiblePassword,
//               prefixIcon: Icons.visibility,
//               iconColor: AppColors.primaryColor,
//               onTapIcon: () => controller.showPass(),
//               filled: true,
//             ),
//             SizedBox(height: 16.h),
//             // حقل تاريخ الميلاد
//             Text("تاريخ الميلاد",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
//             SizedBox(height: 15.h),
//             MyTextformfield(
//               mycontroller: controller.birthDateController,
//               keyboardType: TextInputType.datetime,
//               prefixIcon: Icons.calendar_today,
//               iconColor: AppColors.primaryColor,
//               filled: true,
//               readOnly: true,
//               onTapTextField: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime.now(),
//                 );

//                 if (pickedDate != null) {
//                   String formattedDate =
//                       DateFormat("yyyy-MM-dd").format(pickedDate);
//                   controller.birthDateController.text = formattedDate;
//                 }
//               },
//             ),
//             SizedBox(height: 16.h),
//             Text("الجنس",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
//             SizedBox(height: 15.h),

//             GetBuilder<SignUpController>(
//               builder: (controller) => Center(
//                 child: Wrap(
//                   alignment: WrapAlignment.center,
//                   spacing: 12.w,
//                   runSpacing: 8.h,
//                   children: [
//                     GenderChip(
//                         label: "ذكر",
//                         icon: Icons.male,
//                         value: "Male",
//                         selectedValue: controller.genderController.text,
//                         onSelected: (val) {
//                           controller.genderController.text = val;
//                           controller.update();
//                         }),
//                     GenderChip(
//                         label: "أنثى",
//                         icon: Icons.female,
//                         value: "Female",
//                         selectedValue: controller.genderController.text,
//                         onSelected: (val) {
//                           controller.genderController.text = val;
//                           controller.update();
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20.h),

//             Text("الصورة الشخصية",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
//             SizedBox(height: 15.h),
//             InkWell(
//               onTap: () async {
//                 final picker = ImagePicker();
//                 final pickedFile =
//                     await picker.pickImage(source: ImageSource.gallery);
//                 if (pickedFile != null) {
//                   controller.imageFile = File(pickedFile
//                       .path); // يجب إضافة imageFile داخل Controller كـ File?
//                   controller.imageController.text = pickedFile.path;
//                 }
//               },
//               child: Container(
//                 height: 150.h,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: controller.imageFile == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.image, size: 50.sp, color: Colors.grey),
//                           SizedBox(height: 10.h),
//                           Text(
//                             'اضغط لاختيار صورة',
//                             style: TextStyle(
//                                 color: Colors.grey[600], fontSize: 14.sp),
//                           ),
//                         ],
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(12.r),
//                         child: Image.file(
//                           controller.imageFile!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       ),
//               ),
//             ),

//             SizedBox(height: 30.h),
//             MyButton(
//               onPressed: () {
//                 controller.signUp();
//               },
//               text: "حفظ",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:driving_school/view/widget/genderchip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:driving_school/controller/sign_up_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({super.key, required this.controller});
  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24.h),
            // الاسم الأول
            Text("الاسم",
                style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
            SizedBox(height: 15.h),
            MyTextformfield(
              valid: (val) => validInput(val, 3, 30, "username"),
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
              valid: (val) => validInput(val, 3, 30, "username"),
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
              valid: (val) => validInput(val, 4, 50, "email"),
              mycontroller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              iconColor: AppColors.primaryColor,
              filled: true,
            ),
            SizedBox(height: 16.h),
            // كلمة المرور
            Text("كلمة المرور",
                style: TextStyle(color: Colors.grey[800], fontSize: 12.sp)),
            SizedBox(height: 15.h),
            MyTextformfield(
              valid: (val) => validInput(val, 8, 50, "password"),
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

            Text("الصورة الشخصية",
                style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
            SizedBox(height: 15.h),
            InkWell(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  controller.imageFile = File(pickedFile
                      .path); // يجب إضافة imageFile داخل Controller كـ File?
                  controller.imageController.text = pickedFile.path;
                }
              },
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: controller.imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 50.sp, color: Colors.grey),
                          SizedBox(height: 10.h),
                          Text(
                            'اضغط لاختيار صورة',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14.sp),
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
    );
  }
}
