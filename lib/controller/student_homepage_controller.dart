import 'package:get/get.dart';

class StudentHomepageController extends GetxController {
  int currentpage = 0;

  changPage(int i) {
    currentpage = i;
    update();
  }
}
