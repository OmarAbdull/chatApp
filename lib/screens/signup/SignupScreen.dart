import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            // Optional: Enable real-time validation as the user types
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                /// Username
                Obx(() {
                  _controller.username.value; // Track username changes
                  return TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: AppLocale.userName.getString(context),
                      hintText: AppLocale.enterUsername.getString(context),
                    ),
                    onChanged: _controller.updateUsername,
                    validator: (value) =>
                        _controller.validateUsername(value, context),
                  );
                }),
                const SizedBox(height: 20),

                /// Phone Number
                Row(
                  children: [
                    CountryPickerDropdown(
                      initialValue: 'SA',
                      itemBuilder: _buildDropdownItem,
                      onValuePicked: (Country country) {
                        _controller.updateCountryCode(country.phoneCode);
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: AppLocale.phoneNumber.getString(context),
                          // Remove prefixText
                        ),
                        onChanged: _controller.updatePhoneNumber,
                        validator: (value) =>
                            _controller.validatePhoneNumber(value, context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Password
                Obx(() {
                  // Track password and visibility changes
                  _controller.password.value;
                  final isVisible = _controller.isPasswordVisible.value;
                  return TextFormField(
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      labelText: AppLocale.password.getString(context),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _controller.togglePasswordVisibility,
                      ),
                    ),
                    onChanged: _controller.updatePassword,
                    validator: (value) =>
                        _controller.validatePassword(value, context),
                  );
                }),
                const SizedBox(height: 20),

                /// Confirm Password
                Obx(() {
                  // Track confirm password and visibility changes
                  _controller.confirmPassword.value;
                  final isVisible = _controller.isConPasswordVisible.value;
                  return TextFormField(
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      labelText: AppLocale.confirmPassword.getString(context),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _controller.toggleConPasswordVisibility,
                      ),
                    ),
                    onChanged: _controller.updateConfirmPassword,
                    validator: (value) =>
                        _controller.validateConfirmPassword(value, context),
                  );
                }),
                const SizedBox(height: 30),

                /// Signup Button
                Obx(
                      () => _controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 40),
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
  Widget _buildDropdownItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      const SizedBox(width: 8),
      Text("+${country.phoneCode}"),
    ],
  );

}