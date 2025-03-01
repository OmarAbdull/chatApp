// bottom_nav_controller.dart
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 1.obs; // Observable index

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}