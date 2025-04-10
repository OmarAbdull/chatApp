import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../modle/WebSocketService.dart';
import '../chat_list/ChatListScreen.dart';
import '../profile/ProfileScreen.dart';
import '../safety_tips/SafetyTipsScreen.dart';
import 'BottomNavController.dart';


class BottomNavBar extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());
  final List<Widget> _screens = [
    ChatListScreen(),
    SafetyTipsScreen(),
    ProfileScreen(),
  ];
   BottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() => _screens[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
            () => CurvedNavigationBar(
          index: controller.currentIndex.value,
          backgroundColor: Colors.transparent,

          color:Theme.of(context).colorScheme.primary,
          buttonBackgroundColor:Theme.of(context).colorScheme.primary,
          height: 60,
          animationDuration: Duration(milliseconds: 300),
          items:  [
            Icon(Icons.chat, size: 30, color:Theme.of(context).colorScheme.surface),
            Icon(Icons.lightbulb, size: 30,  color:Theme.of(context).colorScheme.surface),
            Icon(Icons.person, size: 30,  color:Theme.of(context).colorScheme.surface),
          ],
          onTap: (index) => controller.changeIndex(index),
        ),
      ),
    );
  }
}