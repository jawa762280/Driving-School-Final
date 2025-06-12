import 'package:driving_school/main.dart';
import 'package:driving_school/view/screen/bookings_sessions_screen.dart';
import 'package:driving_school/view/screen/profile_screen.dart';
import 'package:driving_school/view/screen/search_screen.dart';
import 'package:driving_school/view/screen/student_homepage_screen.dart';
import 'package:get/get.dart';

class StudentHomepageController extends GetxController {
  int currentpage = 0;
  List pages = [
    StudentHomePageScreen(),
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
    // ignore: avoid_print
    print(data.read('user'));
    super.onInit();
  }
}
