// import 'package:driving_school/core/constant/approuts.dart';
// import 'package:driving_school/core/services/services.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Mymiddleware extends GetMiddleware {
//   @override
//   int? get priority => 1;

//   MyServices myServices = Get.find();
//   @override
//   RouteSettings? redirect(String? route) {
//     if (myServices.sharedpreferences.getString("step") == "2") {
//       return const RouteSettings(name: AppRouts.homepage);
//     }
//     if (myServices.sharedpreferences.getString("step") == "1") {
//       return const RouteSettings(name: AppRouts.loginScreen);
//     }

//     return null;
//   }
// }
