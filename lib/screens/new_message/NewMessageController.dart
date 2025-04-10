import 'package:chat_app/modle/api/ApiServixe.dart';
import 'package:get/get.dart';

import '../../modle/database/App_db.dart';

class NewMessageController extends GetxController {
  final ApiService _apiService = ApiService();
  final AppDatabase _appDatabase = AppDatabase();

  Future<void> checkUserAndStartChat(String phoneNumber) async {
    try {
      final response = await _apiService.authenticatedPost(
        'Users/getUserData',
        {"ID": phoneNumber, "PhoneNumber": phoneNumber},
      );

      if (response['code'] == 1000) {
        final userData = response['result'];
        final userId = userData['id'] as int;
        final userKey = userData['userKey'] as String;
        final String base64image = userData['userImage'] ?? '';
        final senderName = userData['name'] ?? phoneNumber;

        // Process base64 image
        String? processedImage = base64image;
        if (base64image.contains(',')) {
          processedImage = base64image.split(',').last;
        }

        // Insert/update chat
        await _appDatabase.insertOrUpdateChat(
          id: userId,
          senderName: senderName,
          userKey: userKey,
          avatarBase64: processedImage,
        );
        print("id: $userId");
        Get.toNamed(
          "/Chat",
          arguments: userId,
          preventDuplicates: true,
        );
      } else {
        Get.snackbar('Error', 'User not found on the server');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start chat: ${e.toString()}');
    }
  }
}
