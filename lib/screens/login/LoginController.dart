// Updated Login Controller (login_controller.dart)
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/app_locale.dart';
import '../../modle/api/ApiServixe.dart';

class   LoginController extends GetxController {
  late var phoneNumber = ''.obs; // Stores national number without country code
  final password = ''.obs;
  late SharedPreferences _prefs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isLogin = false.obs;
  var isLoggedIn = false.obs;

  final ApiService _apiService = ApiService();
  Future<void> _initializeTheme() async {
    _prefs = await SharedPreferences.getInstance();
  }
  void updatePhoneNumber(String value) => phoneNumber.value = value;

  void updatePassword(String value) => password.value = value;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  String? validatePhoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty && isLogin.value) {
      return AppLocale.getString(context, AppLocale.enterPhoneNumber);
    }
    if (!RegExp(r'^(70|71|73|77|78)\d{7}$').hasMatch(value) && isLogin.value) {
      return AppLocale.getString(context, AppLocale.invalidPhoneFormat);
    }
    return null;
  }

  String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty && isLogin.value) {
      return AppLocale.getString(context, AppLocale.enterPassword);
    }
    if (value.length < 6 && isLogin.value) {
      return AppLocale.getString(context, AppLocale.passwordLength);
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    isLogin.value = true;
    // Add context parameter
    if (validatePhoneNumber(phoneNumber.value, context) != null &&
        validatePassword(password.value, context) != null) {
      // Add context
      return;
    }
    final fullNumber = '+967${phoneNumber.value}';
    print('Attempting login with: $fullNumber');

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    try {
      isLoading(true);
      final response = await _apiService.post('login', {
        'phoneNumber': phoneNumber,
        'password': password,
      });

      // Save token to local storage
      await _prefs.setString('auth_token', response['token']);

      isLoggedIn(true);
      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
