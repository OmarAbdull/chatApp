import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import '../../../MyAppController.dart';
import '../../../localization/app_locale.dart';
import '../ProfileController.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContactDetail(),
        ContactStatus(),
      ],
    );
  }
}

class ContactDetail extends StatelessWidget {
  final ProfileController controller = Get.find();

  ContactDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => _buildListTile(
              icon: Icons.phone_android,
              title: AppLocale.phoneNumber.getString(context),
              value: controller.phone.value,
            )),

          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(
      {required IconData icon, required String title, required String value}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(color: Colors.black),
      ),
      dense: true,
    );
  }
}

class ContactStatus extends StatelessWidget {
  final ProfileController controller = Get.find();
  final settingController = Get.find<MyAppController>();

  ContactStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return  Card(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child:Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('English'),
                        onPressed: () => settingController.changeLanguage('en'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('العربية'),
                        onPressed: () => settingController.changeLanguage('ar'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Wrap only theme selection in Obx
              Obx(() => Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(AppLocale.lightTheme.getString(context)),
                    value: ThemeMode.light,
                    groupValue: settingController.themeMode.value,
                    onChanged: (value) => settingController.changeTheme(value!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(AppLocale.darkTheme.getString(context)),
                    value: ThemeMode.dark,
                    groupValue: settingController.themeMode.value,
                    onChanged: (value) => settingController.changeTheme(value!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(AppLocale.systemTheme.getString(context)),
                    value: ThemeMode.system,
                    groupValue: settingController.themeMode.value,
                    onChanged: (value) => settingController.changeTheme(value!),
                  ),
                ],
              ))
            ],
          ),
        )


    );
  }
}