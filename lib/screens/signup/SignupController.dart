// Updated Login Controller (login_controller.dart)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

import '../../localization/app_locale.dart';
import '../../modle/api/ApiServixe.dart';

class SignupController extends GetxController {
  final ApiService _apiService = ApiService();
  final phoneNumber = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final username = ''.obs;
  final isPasswordVisible = false.obs;
  final isConPasswordVisible = false.obs;
  final isLoading = false.obs;


  void updatePhoneNumber(String value) => phoneNumber.value = value;

  void updatePassword(String value) => password.value = value;

  void updateConfirmPassword(String value) => confirmPassword.value = value;

  void updateUsername(String value) => username.value = value;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void toggleConPasswordVisibility() => isConPasswordVisible.toggle();

  String? validatePhoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty ) {
      print(AppLocale.enterPhoneNumber.getString(context));

      return AppLocale.getString(context, AppLocale.enterPhoneNumber);
    }
    if (!RegExp(r'^5[0-9]{8}$').hasMatch(value) ) {
      print(AppLocale.invalidPhoneFormat.getString(context));

      return AppLocale.getString(context, AppLocale.invalidPhoneFormat);
    }
    return null;
  }

  String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty ) {
      print(AppLocale.enterPassword.getString(context));

      return AppLocale.getString(context, AppLocale.enterPassword);
    }
    if (value.length < 6 ) {
      print(AppLocale.passwordLength.getString(context));

      return AppLocale.getString(context, AppLocale.passwordLength);
    }
    return null;
  }

  //
  // String? validateEmail(String? value, BuildContext context) {
  //   final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  //   if (value == null || value.isEmpty && isSignup.value) {
  //     return AppLocale.enterEmail.getString(context);
  //   } else if (!emailRegex.hasMatch(value) && isSignup.value) {
  //     return AppLocale.emailNotValid.getString(context);
  //   }
  //   return null;
  // }

  String? validateConfirmPassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty ) {
      print(AppLocale.enterConfirmPassword.getString(context));
      return AppLocale.enterConfirmPassword.getString(context);
    } else if (value != password.value ) {
      print(AppLocale.matchPassword.getString(context));
      return AppLocale.matchPassword.getString(context);
    }
    return null;
  }

  String? validateUsername(String? value, BuildContext context) {
    if (value == null || value.isEmpty ) {
      return AppLocale.getString(context, AppLocale.enterUsername);
    }
    return null;
  }

  Future<void> signup(BuildContext context) async {
    isLoading.value= true;
    // Validate fields
    if (validatePhoneNumber(phoneNumber.value, context) != null ||
        validateConfirmPassword(password.value, context) != null ||
        validateUsername(username.value, context) != null ||
        validatePassword(password.value, context) != null) {
      isLoading(false);
      return;
    }

    try {
      final response = await _apiService.post(
          'Auth/register',
          ({
            "userName": username.value,
            "phoneNumber": phoneNumber.value,
            "password": password.value,
            "userType": "2"
          }));

      if (response['code'] == 1000) {
        Get.offAllNamed('/Login');
      } else {
        Get.snackbar(
          AppLocale.getString(context, AppLocale.signupFailed),
          response.data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
