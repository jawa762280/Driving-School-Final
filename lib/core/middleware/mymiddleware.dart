import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (data.read('user') != null) {
      if ((data.read('role').toString() == 'student')) {
        return const RouteSettings(name: AppRouts.studentHomePageScreen);
      } else if ((data.read('role').toString() == 'trainer')) {
        // هنا توجيه مدرب للصفحة المناسبة
        return const RouteSettings(name: AppRouts.trainerHomePageScreen);
      }
    }
    return null;
  }
}
