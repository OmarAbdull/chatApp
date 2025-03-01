// Updated Login Screen (login_screen.dart)
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
      appBar: AppBar(title:  Center(child: Text(AppLocale.signup.getString(context)))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ///User Name
              Obx(() => TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: AppLocale.userName.getString(context),
                  prefixText: '+967 ',
                  hintText: '701234567',
                  errorText: _controller.validateUsername(_controller.username.value,context),
                ),
                onChanged: _controller.updateUsername,
                validator: (value) => _controller.validateUsername(value,context),
              )),
              const SizedBox(height: 20),

              /// User Phone Number
              Obx(() => TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocale.phoneNumber.getString(context),
                  errorText: _controller.validatePhoneNumber(_controller.phoneNumber.value,context),
                ),
                onChanged: _controller.updatePhoneNumber,
                validator: (value) => _controller.validatePhoneNumber(value,context),
              )),
              const SizedBox(height: 20),

              /// User Email
              // Obx(() => TextFormField(
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: InputDecoration(
              //     labelText: AppLocale.email.getString(context),
              //     errorText: _controller.validateEmail(_controller.email.value,context),
              //   ),
              //   onChanged: _controller.updateEmail,
              //   validator: (value) => _controller.validateEmail(value,context),
              // )),
              // const SizedBox(height: 20),

              /// User Password
              Obx(() => TextFormField(
                obscureText: !_controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: AppLocale.password.getString(context),
                  errorText: _controller.validatePassword(_controller.password.value,context),
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
                validator: (value) => _controller.validatePassword(value,context),
              )),
              const SizedBox(height: 20),

              ///Confirm Password
              Obx(() => TextFormField(
                obscureText: !_controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: AppLocale.password.getString(context),
                  errorText: _controller.validateConfirmPassword(_controller.confirmPassword.value,context),
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
                validator: (value) => _controller.validateConfirmPassword(value,context),
              )),
              const SizedBox(height: 30),

              ///Signup Button
              Obx(() => _controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(200, 40)),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _controller.signup(context);
                  }
                },
                child:  Text(AppLocale.signup.getString(context)),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}