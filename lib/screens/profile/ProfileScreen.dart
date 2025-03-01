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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 48, 160, 211),
        titleTextStyle: const TextStyle(color: Colors.white),
        toolbarHeight: 200,
        title: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Center(
            child: Column(
              children: [
                const ProfilePhotos(),
                const ProfileName(),
                const SubName(),
                const Padding(padding: EdgeInsets.only(top: 10.0)),
              ],
            ),
          ),
        ),
      ),
      body: const ContactSection(),
    );
  }
}