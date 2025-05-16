import 'package:driving_school/core/services/services.dart';
import 'package:driving_school/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> initialServices() async {
  await Get.putAsync(() async => await MyServices().init());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(fontFamily: 'Cairo'),
          debugShowCheckedModeBanner: false,
          getPages: routes,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
