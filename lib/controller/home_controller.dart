import 'package:get/get.dart';

class HomeController extends GetxController {
  int _selectedIndex = 0;
  var error = "";

  void showSubjects() {
    _selectedIndex = 0;
    update();
  }

  void showProfile() {
    _selectedIndex = 1;
    update();
  }

  int stIndex() {
    return _selectedIndex;
  }
}
