import 'package:chat_app/localization/app_locale.dart';
import 'package:chat_app/screens/new_message/NewMessageController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart'; // تأكد من استيراد الحزمة الصحيحة
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final NewMessageController controller = Get.put(NewMessageController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          AppLocale.newContact.getString(context),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: AppLocale.enterPhoneNumber.getString(context),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () async {
                    final phoneNumber = phoneController.text.trim();
                    if (phoneNumber.isNotEmpty) {
                      await controller.checkUserAndStartChat(phoneNumber);
                    } else {
                      Get.snackbar(
                        'Error',
                        AppLocale.enterPhoneNumber.getString(context),
                      );
                    }
                  },
                  child: Text(
                    AppLocale.startChat.getString(context),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final contact = await _pickContact();
                    if (contact != null) {
                      phoneController.text = contact.phones.first.number;
                    }
                  },
                  child: Text(AppLocale.pickContacts.getString(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Contact?> _pickContact() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final contact = await FlutterContacts.openExternalPick();
        return contact;
      } else {
        Get.snackbar('Permission Denied', 'Contacts permission is required');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick contact: $e');
      return null;
    }
  }
}
