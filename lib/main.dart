import 'package:driving_school/controller/chat_controller.dart';
import 'package:driving_school/controller/chat_people_controller.dart';
import 'package:driving_school/controller/generate_exam_controller.dart';
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
}

String mytoken = 'UNKNOWN';

/// ✅ معالج الإشعارات عند وصولها بالخلفية أو إغلاق التطبيق
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📥 إشعار بالخلفية (onBackgroundMessage):");
  print("🔔 Title: ${message.notification?.title}");
  print("📝 Body: ${message.notification?.body}");
  print("📦 Data: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => PusherService().init());

  // ✅ تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ تسجيل معالج الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ طلب صلاحيات الإشعارات
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
  print('📛 Notification permission status: ${settings.authorizationStatus}');

  // ✅ الحصول على التوكن
  mytoken = (await FirebaseMessaging.instance.getToken()) ?? 'UNKNOWN';
  print("📲 FCM Token: $mytoken");

  // ✅ الاستماع للإشعارات عندما يكون التطبيق مفتوحًا
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('✅ استلمنا إشعار أثناء فتح التطبيق (onMessage)');
    print('🔔 Title: ${message.notification?.title}');
    print('📝 Body: ${message.notification?.body}');
    print('📦 Data: ${message.data}');
  });

  // ✅ عند فتح التطبيق من إشعار
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 تم فتح التطبيق من الإشعار (onMessageOpenedApp)');
    print('📦 Data: ${message.data}');
  });

  // ✅ عند تشغيل التطبيق من إشعار وهو مغلق تمامًا
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('🚀 تم تشغيل التطبيق من إشعار مغلق مسبقاً (getInitialMessage)');
      print('📦 Data: ${message.data}');
    }
  });

  // ✅ تحميل الخدمات والتهيئة العامة
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
