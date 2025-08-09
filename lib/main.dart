import 'package:driving_school/controller/generate_exam_controller.dart';
import 'package:driving_school/core/functions/background_service.dart';
import 'package:driving_school/core/services/pusher_service.dart';
import 'package:driving_school/core/services/services.dart';
import 'package:driving_school/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> initialServices() async {
  await Get.putAsync(() async => await MyServices().init());
  await initializeBackgroundService();
}

String mytoken = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => PusherService().init());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  mytoken = (await FirebaseMessaging.instance.getToken()) ?? 'null';
  // ignore: avoid_print
  print("📲 FCM Token: $mytoken");

  await initialServices();
  await initializeDateFormatting('ar');

  Get.put(GenerateExamController(), permanent: true);

  runApp(const MyApp());
}

GetStorage data = GetStorage();

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
          initialRoute: "/",
          locale: const Locale('ar'),
          fallbackLocale: const Locale('ar'),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
