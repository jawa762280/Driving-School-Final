import 'package:driving_school/main.dart';
import 'package:driving_school/view/screen/bookings_sessions_screen.dart';
import 'package:driving_school/view/screen/profile_screen.dart';
import 'package:driving_school/view/screen/search_screen.dart';
import 'package:driving_school/view/screen/trainer_homepage_screen.dart';
import 'package:get/get.dart';

class TrainerHomepageController extends GetxController {
  int currentpage = 0;
  List pages = [
    TrainerHomePageScreen(),
    ProfileScreen(),
    SearchScreen(),
    BookingsSessionsScreen(),
  ];

  changPage(int i) {
    currentpage = i;
    update();
  }

  @override
  void onInit() {
    print(data.read('token'));
    super.onInit();
  }
}
