import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha((0.3 * 255).toInt()),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 60.0,
            ),
            const SizedBox(height: 20),
            const Text(
              "جاري المعالجة...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
