import 'package:driving_school/main.dart';
import 'package:driving_school/view/screen/bookings_sessions_screen.dart';
import 'package:driving_school/view/screen/profile_screen.dart';
import 'package:driving_school/view/screen/search_screen.dart';
import 'package:driving_school/view/screen/trainer_homepage_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainerHomepageController extends GetxController {
  int currentpage = 0;
  List pages = [
    TrainerHomePageScreen(),
    BookingsSessionsScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  changPage(int i) {
    currentpage = i;
    update();
  }

  getToken() async {
    await Permission.notification.request();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.requestPermission();
    await firebaseMessaging
        .getToken()
        .then((value) => mytoken = value.toString());
    // ignore: avoid_print
    print('$mytoken token');
    await firebaseMessaging.subscribeToTopic("allusers");
  }

  @override
  void onInit() {
    // ignore: avoid_print
    print(data.read('token'));
    getToken();
    super.onInit();
  }
}
