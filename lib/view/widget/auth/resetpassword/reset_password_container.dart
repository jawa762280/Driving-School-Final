import 'package:driving_school/controller/resetpassword_controller.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';

class ResetPasswordContainer extends StatelessWidget {
  const ResetPasswordContainer({super.key, required this.controller});
  final ResetPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: controller.formState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Center(
              child: Text(
                "اعادة تعيين كلمة المرور",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Text("ادخل كلمة المرور الجديدة",
                style: TextStyle(color: Colors.grey[800], fontSize: 11)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 8, 50, "password"),
              mycontroller: controller.passController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.isShowPass,
              prefixIcon: Icons.visibility,
              onTapIcon: () => controller.showPass(),
              filled: true,
            ),
            SizedBox(
              height: 16,
            ),
            Text("تأكيد كلمة المرور الجديدة",
                style: TextStyle(color: Colors.grey[800], fontSize: 11)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 8, 50, "password"),
              mycontroller: controller.rePassController,
              obscureText: controller.isShowRePass,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Icons.visibility,
              onTapIcon: () => controller.showRePass(),
              filled: true,
            ),
            SizedBox(
              height: 30,
            ),
            MyButton(
              onPressed: () {
                controller.save();
              },
              text: "حفظ",
            ),
          ],
        ),
      ),
    );
  }
}
