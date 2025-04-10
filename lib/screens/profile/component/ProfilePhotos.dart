import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../ProfileController.dart';

class ProfilePhotos extends StatelessWidget {
  const ProfilePhotos({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();

    void _showImagePickerOptions() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Picture'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Obx(
          () => Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        width: 105,
        height: 105,
        alignment: Alignment.center,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: controller.profileImageFile.value != null
                  ? FileImage(controller.profileImageFile.value!)
                  : NetworkImage(controller.defaultProfileImageUrl)
              as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}