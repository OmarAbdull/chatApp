import 'package:chat_app/screens/bottom_nav_bar/BottomNavBar.dart';
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
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: controller.themeMode.value,
        locale: controller.currentLocale.value,
        supportedLocales: controller.supportedLocales,
        localizationsDelegates: controller.localizationsDelegates,
        home: Builder(
          builder: (context) {
            return Directionality(
              textDirection: controller.textDirection,
              child: BottomNavBar(),
            );
          },
        ),
      );
    });
  }
}