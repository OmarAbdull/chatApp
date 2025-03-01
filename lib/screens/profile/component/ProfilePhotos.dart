// profile_photos.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ProfileController.dart';

class ProfilePhotos extends StatelessWidget {
  const ProfilePhotos({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();
    return Obx(
          () => Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        width: 105,
        height: 105,
        alignment: Alignment.center,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(controller.profileImageUrl.value),
        ),
      ),
    );
  }
}

