import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modle/api/ApiServixe.dart';

class ProfileController extends GetxController {
  // Profile Section
  final ApiService _apiService = ApiService();

  static const String _nameKey = 'user_name';
  final RxBool isUpdating = false.obs;
  final phone = "+62 812345678".obs;
  final email = "aseps.career@gmail.com".obs;
  final website = "asepsaputra.medium.com".obs;
  final status = "Available".obs;
  final name = "".obs;
  final subTitle = "Traveller - Dreamer - Fighter".obs;
  final Rx<File?> profileImageFile = Rx<File?>(null);
  final String defaultProfileImageUrl = "https://picsum.photos/300/300";
  final ImagePicker _picker = ImagePicker();
  static const String _imagePathKey = 'profile_image_path';

  @override
  void onInit() {
    super.onInit();
    _loadImagePath();
    _loadName(); // Load saved name when controller initializes
  }

  void _loadName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      name.value = prefs.getString(_nameKey) ?? "Asep Saputra";
    } catch (e) {
      Get.snackbar('Error', 'Failed to load name: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      isUpdating(true);
      final String userName = name.value;
      String userImageBase64 = '';

      if (profileImageFile.value != null) {
        final bytes = await profileImageFile.value!.readAsBytes();
        userImageBase64 = base64Encode(bytes);
      }

      await _apiService.authenticatedPost(
        'Users/updateUserDate',
        {
          'UserName': userName,
          'UserImage': userImageBase64,
        },
      );
      isUpdating(false);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      isUpdating(false);
      Get.snackbar('Error', 'Failed to update server data: $e');
      rethrow;
    }
  }

  Future<void> updateName(String newName) async {
    try {
      if (newName.trim().isEmpty) return;
      name.value = newName.trim();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, newName.trim());
      await _updateUserData(); // Add API update
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name: $e');
    }
  }

  Future<void> _loadImagePath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString(_imagePathKey);

      if (path != null && await File(path).exists()) {
        profileImageFile.value = File(path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile image: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? xFile = await _picker.pickImage(source: source);
      if (xFile == null) return;

      final File newImage = File(xFile.path);
      final String savedPath = await _saveImageToLocalStorage(newImage);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_imagePathKey, savedPath);

      profileImageFile.value = newImage;
      await _updateUserData(); // Add API update
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

  Future<String> _saveImageToLocalStorage(File image) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/profile_image.jpg';
      await image.copy(path);
      return path;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  void logout() {
    Get.offAllNamed('/Login');
  }
}
