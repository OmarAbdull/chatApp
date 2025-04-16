// login_screen.dart (updated)
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

import '../../localization/app_locale.dart';
import 'SignupController.dart';

class SignupScreen extends StatelessWidget {
  final SignupController _controller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Center(
              child: Text(
                AppLocale.signup.getString(context),
                style: const TextStyle(color: Colors.white),
              ))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// User Name
                Obx(() => TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: AppLocale.userName.getString(context),
                    hintText: AppLocale.enterUsername.getString(context),
                    errorText: _controller.validateUsername(
                        _controller.username.value, context),
                  ),
                  onChanged: _controller.updateUsername,
                  validator: (value) =>
                      _controller.validateUsername(value, context),
                )),
                const SizedBox(height: 20),
          
                /// User Phone Number
                Obx(() => TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppLocale.phoneNumber.getString(context),
                    prefixText: '+966 ',
                    hintText: ' 512345678',
                    errorText: _controller.validatePhoneNumber(
                        _controller.phoneNumber.value, context),
                  ),
                  onChanged: _controller.updatePhoneNumber,
                  validator: (value) =>
                      _controller.validatePhoneNumber(value, context),
                )),
                const SizedBox(height: 20),
          
                /// User Password
                Obx(() => TextFormField(
                  obscureText: !_controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: AppLocale.password.getString(context),
                    errorText: _controller.validatePassword(
                        _controller.password.value, context),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _controller.togglePasswordVisibility,
                    ),
                  ),
                  onChanged: _controller.updatePassword,
                  validator: (value) =>
                      _controller.validatePassword(value, context),
                )),
                const SizedBox(height: 20),
          
                /// Confirm Password
                Obx(() => TextFormField(
                  obscureText: !_controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: AppLocale.confirmPassword.getString(context),
                    errorText: _controller.validateConfirmPassword(
                        _controller.confirmPassword.value, context),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _controller.togglePasswordVisibility,
                    ),
                  ),
                  onChanged: _controller.updateConfirmPassword,
                  validator: (value) =>
                      _controller.validateConfirmPassword(value, context),
                )),
                const SizedBox(height: 30),
          
                /// Signup Button
                Obx(
                      () => _controller.isSignup.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 40),
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _controller.signup(context);
                      }
                    },
                    child: Text(
                      AppLocale.signup.getString(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}