import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ProfileController.dart';
import 'component/ContactSection.dart';
import 'component/ProfileName.dart';
import 'component/ProfilePhotos.dart';
import 'component/SubName.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isUpdating.value) {
        return const CircularProgressIndicator();
      }
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,

        appBar: AppBar(
          automaticallyImplyLeading: false, // This removes the back button
          backgroundColor:Theme.of(context).colorScheme.primary,
          titleTextStyle:  TextStyle(color: Colors.white),
          toolbarHeight: 200,
          title: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(), // Pushes everything to the right
                        Center(child: ProfilePhotos()),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.logout, color: Colors.white),
                              onPressed: () => controller.logout(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const ProfileName(),
                    const SubName(),
                    const Padding(padding: EdgeInsets.only(top: 10.0)),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(child: const ContactSection()),
      );
    });
  }
}