import 'package:driving_school/view/screen/profile_screen.dart';
import 'package:driving_school/view/screen/search_screen.dart';
import 'package:driving_school/view/screen/trainer_homepage_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TrainerHomepageController extends GetxController {
  int currentpage = 0;
  List pages = [
    TrainerHomePageScreen(),
    ProfileScreen(),
    SearchScreen(),
    Center(child: Text('4')),
  ];

  changPage(int i) {
    currentpage = i;
    update();
  }
}
