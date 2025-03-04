import 'package:chat_app/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart'; // تأكد من استيراد الحزمة الصحيحة
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

import '../chat/ChatScreen.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
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
            ElevatedButton(
              onPressed: () {
                final phoneNumber = phoneController.text.trim();
                if (phoneNumber.isNotEmpty) {
                  // الانتقال إلى شاشة المحادثة مع الرقم المدخل
                  Get.to(() => ChatScreen(conversationId: phoneNumber));
                } else {
                  Get.snackbar('Error', AppLocale.enterPhoneNumber.getString(context));
                }
              },
              child: const Text('Start Chat'),
            ),
            const SizedBox(height: 20),
            const Text('OR'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // فتح جهات الاتصال للبحث عن رقم
                final contact = await _pickContact();
                if (contact != null) {
                  phoneController.text = contact.phones.first.number; // استخدام number بدلاً من value
                }
              },
              child:  Text(AppLocale.pickContacts.getString(context)),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لفتح جهات الاتصال
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