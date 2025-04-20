import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

import '../../localization/app_locale.dart';
import 'LoginController.dart';

class LoginScreen extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Center(
              child: Text(
            AppLocale.login.getString(context),
            style: TextStyle(color: Colors.white),
          ))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CountryPickerDropdown(
                        initialValue: 'SA',
                        itemBuilder: (country) =>
                            _buildDropdownItem(context, country),
                        // Pass context here
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
                  TextFormField(
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
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() => _controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  fixedSize: Size(200, 40)),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _controller.login(context);
                                }
                              },
                              child: Text(
                                AppLocale.login.getString(context),
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      OutlinedButton(
                        onPressed: () => Get.toNamed('/SignUp'),
                        child: Text(AppLocale.signup.getString(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(BuildContext context, Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8),
          Text(
            "+${country.phoneCode}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      );
}
