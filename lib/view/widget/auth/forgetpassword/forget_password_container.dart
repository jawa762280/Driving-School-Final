import 'package:driving_school/controller/forget_password_controller.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';

class ForgetPasswordContainer extends StatelessWidget {
  final ForgetPasswordController controller;
  const ForgetPasswordContainer({super.key, required this.controller});

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
                "هل نسيت كلمة المرور ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Text("ادخل البريد الالكتروني",
                style: TextStyle(color: Colors.grey[800], fontSize: 12)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 4, 20, "email"),
              mycontroller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              filled: true,
            ),
            SizedBox(
              height: 10,
            ),
            Text("سيتم ارسال رقم التحقق الى البريد ",
                style: TextStyle(color: Colors.grey[800], fontSize: 11)),
            SizedBox(
              height: 30,
            ),
            MyButton(
              onPressed: () {
                controller.sendEmail();
              },
              text: "ارسال",
            ),
          ],
        ),
      ),
    );
  }
}
