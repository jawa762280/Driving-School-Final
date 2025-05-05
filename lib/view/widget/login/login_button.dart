import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final void Function()? onPressed;

  const LoginButton({super.key, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        label:
            const Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
