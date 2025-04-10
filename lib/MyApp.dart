import 'package:chat_app/screens/bottom_nav_bar/BottomNavBar.dart';
import 'package:chat_app/screens/chat/ChatScreen.dart';
import 'package:chat_app/screens/chat_list/ChatListScreen.dart';
import 'package:chat_app/screens/login/LoginScreen.dart';
import 'package:chat_app/screens/profile/ProfileScreen.dart';
import 'package:chat_app/screens/safety_tips/SafetyTipsScreen.dart';
import 'package:chat_app/screens/signup/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'MyAppController.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyAppController>();
    return Obx(() {
      return GetMaterialApp(
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xFF25337a),
            onPrimaryContainer: Colors.grey.shade500,
            // Primary color
            secondary: Colors.blue.shade900,
            // Secondary color
            onSecondary: Colors.black,
            surface: Color(0xFFeaf2f8),
            // Surface color
            onPrimary: Colors.white,
            // Text/icon color on primary
            error: Colors.red.shade700, // Error color
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black87),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade900,
            onPrimaryContainer: Colors.grey.shade400,
            // Primary color
            secondary: Colors.blue.shade200,
            onSecondary: Colors.white,
            surface: Colors.grey.shade900,
            onPrimary: Colors.black87,
            error: Colors.red.shade400,
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white70),
          ),
        ),
        themeMode: controller.themeMode.value,
        locale: controller.currentLocale.value,
        supportedLocales: controller.supportedLocales,
        localizationsDelegates: controller.localizationsDelegates,
        home: Builder(
          builder: (context) {
            return Directionality(
              textDirection: controller.textDirection,
              child: controller.loggedIn.value ? BottomNavBar() : LoginScreen(),
            );
          },
        ),
        getPages: [
          GetPage(name: "/BottomNavBar", page: () => BottomNavBar()),
          GetPage(
            name: "/Chat",
            page: () {
              final args = Get.arguments;
              return ChatScreen(
                chatId: args is Map ? args['chatId'] : args as int,
              );
            },
          ),
          GetPage(name: "/SignUp", page: () => SignupScreen()),
          GetPage(name: "/Login", page: () => LoginScreen()),
          GetPage(name: "/Profile", page: () => ProfileScreen()),
          GetPage(name: "/ChatList", page: () => ChatListScreen()),
          GetPage(name: "/Tips", page: () => SafetyTipsScreen()),
        ],
      );
    });
  }
}
