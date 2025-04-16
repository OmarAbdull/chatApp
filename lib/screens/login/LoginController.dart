// Updated Login Controller (login_controller.dart)
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/app_locale.dart';
import '../../modle/WebSocketService.dart';
import '../../modle/api/ApiServixe.dart';

class   LoginController extends GetxController {
  late var phoneNumber = ''.obs; // Stores national number without country code
  final password = ''.obs;
  SharedPreferences? _prefs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isLogin = false.obs;
  var isLoggedIn = false.obs;

  final ApiService _apiService = ApiService();
  @override
  Future<void> onInit() async {

    super.onInit();
    await _initializeSharedPreferences();
  }
  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }



  void updatePhoneNumber(String value) => phoneNumber.value = value;

  void updatePassword(String value) => password.value = value;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  String? validatePhoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty && isLogin.value) {
      return AppLocale.getString(context, AppLocale.enterPhoneNumber);
    }
    if (!RegExp(r'^5[0-9]{8}$').hasMatch(value) && isLogin.value) {
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
    if (_prefs == null) {
      await _initializeSharedPreferences();
    }
    // Validate fields
    if (validatePhoneNumber(phoneNumber.value, context) != null ||
        validatePassword(password.value, context) != null) {
      isLoading(false);
      return;
    }

    try {
      isLoading(true);
      final response = await _apiService.post('Auth/login', {
        'PHONENUMBER': phoneNumber.value, // Uppercase key
        'PASSWORD': password.value,
      });

      // Check API response code
      if (response['code'] == 1000) {
        _prefs?.setString("auth_token", response['result']['token']);
        _prefs?.setString("user_key", response['result']['userKey']);
        _prefs?.setString("user_name", response['result']['username']);
        print("Token  : ${response['result']['token']}");
        isLoggedIn(true);
        final webSocketService = WebSocketService();
        await webSocketService.connect();
        Get.offNamed('/BottomNavBar'); // Navigate on success
      } else {
        Get.snackbar('Error', response['message'] ?? 'Login failed');
        print("Respons" +response);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e);

    } finally {
      isLoading(false);
    }
  }
}