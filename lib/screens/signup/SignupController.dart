// Updated Login Controller (login_controller.dart)
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

import '../../localization/app_locale.dart';

class SignupController extends GetxController {
  late var phoneNumber = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final username = ''.obs;
  final email = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isSignup = false.obs;

  void updatePhoneNumber(String value) => phoneNumber.value = value;

  void updatePassword(String value) => password.value = value;

  void updateConfirmPassword(String value) => confirmPassword.value = value;

  void updateUsername(String value) => username.value = value;

  void updateEmail(String value) => email.value = value;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  String? validatePhoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty && isSignup.value) {
      return AppLocale.getString(context, AppLocale.enterPhoneNumber);
    }
    if (!RegExp(r'^(70|71|73|77|78)\d{7}$').hasMatch(value) && isSignup.value) {
      return AppLocale.getString(context, AppLocale.invalidPhoneFormat);
    }
    return null;
  }

  String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty && isSignup.value) {
      return AppLocale.getString(context, AppLocale.enterPassword);
    }
    if (value.length < 6 && isSignup.value) {
      return AppLocale.getString(context, AppLocale.passwordLength);
    }
    return null;
  }

  String? validateEmail(String? value, BuildContext context) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (value == null || value.isEmpty && isSignup.value) {
      return AppLocale.enterEmail.getString(context);
    } else if (!emailRegex.hasMatch(value) && isSignup.value) {
      return AppLocale.emailNotValid.getString(context);
    }
    return null;
  }

  String? validateConfirmPassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty && isSignup.value) {
      return AppLocale.enterConfirmPassword.getString(context);
    } else if (value != password && isSignup.value) {
        return AppLocale.matchPassword.getString(context);
    }
    return null;
  }

  String? validateUsername(String? value, BuildContext context) {
    if (value == null || value.isEmpty && isSignup.value) {
      return AppLocale.getString(context, AppLocale.enterUsername);
    }
    return null;
  }

  Future<void> signup(BuildContext context) async       {
    isSignup.value = true;
    // Add context parameter
    if (validatePhoneNumber(username.value, context) != null &&
        validatePassword(phoneNumber.value, context) != null &&
        validatePassword(email.value, context) != null &&
        validatePassword(password.value, context) != null &&
        validatePassword(confirmPassword.value, context) != null) {
      // Add context
      return;
    }

    isLoading.value = true;
    final fullNumber = '+967${phoneNumber.value}';
    print('Attempting login with: $fullNumber');

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    if (phoneNumber.value == '701234567' && password.value == 'password') {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        AppLocale.getString(context, AppLocale.loginFailed), // Localized title
        AppLocale.getString(context, AppLocale.invalidCredentials),
        // Localized message
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
