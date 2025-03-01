import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ProfileController.dart';

class ProfileName extends StatelessWidget {
  const ProfileName({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();
    return Obx(
          () => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          controller.name.value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}