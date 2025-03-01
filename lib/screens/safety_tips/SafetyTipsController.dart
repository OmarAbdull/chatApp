import 'package:flutter/material.dart'; // Import BuildContext
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../localization/app_locale.dart';
import '../../modle/data/SafetyTip.dart';

class SafetyTipsController extends GetxController {
  final RxList<SafetyTip> tips = <SafetyTip>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  late BuildContext context; // Add BuildContext as a member variable

  SafetyTipsController(this.context); // Constructor to initialize context

  @override
  void onInit() {
    super.onInit();
    fetchSafetyTips();
  }

  Future<void> fetchSafetyTips() async {
    try {
      isLoading.value = true;

      // Fetch localized strings using the context
      String safetyTipKeepInfoPrivateTitle = AppLocale.getString(context, AppLocale.safetyTipKeepInfoPrivateTitle);
      String safetyTipKeepInfoPrivateDesc = AppLocale.getString(context, AppLocale.safetyTipKeepInfoPrivateDesc);
      String safetyTipVerifyContactsTitle = AppLocale.getString(context, AppLocale.safetyTipVerifyContactsTitle);
      String safetyTipVerifyContactsDesc = AppLocale.getString(context, AppLocale.safetyTipVerifyContactsDesc);
      String safetyTipUseStrongPasswordsTitle = AppLocale.getString(context, AppLocale.safetyTipUseStrongPasswordsTitle);
      String safetyTipUseStrongPasswordsDesc = AppLocale.getString(context, AppLocale.safetyTipUseStrongPasswordsDesc);
      String safetyTipEnable2FATitle = AppLocale.getString(context, AppLocale.safetyTipEnable2FATitle);
      String safetyTipEnable2FADesc = AppLocale.getString(context, AppLocale.safetyTipEnable2FADesc);
      String safetyTipBewarePhishingTitle = AppLocale.getString(context, AppLocale.safetyTipBewarePhishingTitle);
      String safetyTipBewarePhishingDesc = AppLocale.getString(context, AppLocale.safetyTipBewarePhishingDesc);
      String safetyTipRegularUpdatesTitle = AppLocale.getString(context, AppLocale.safetyTipRegularUpdatesTitle);
      String safetyTipRegularUpdatesDesc = AppLocale.getString(context, AppLocale.safetyTipRegularUpdatesDesc);

      // Add your actual safety tips here
      tips.assignAll([
        SafetyTip(
            title: safetyTipKeepInfoPrivateTitle,
            description: safetyTipKeepInfoPrivateDesc),
        SafetyTip(
            title: safetyTipVerifyContactsTitle,
            description: safetyTipVerifyContactsDesc),
        SafetyTip(
            title: safetyTipUseStrongPasswordsTitle,
            description: safetyTipUseStrongPasswordsDesc),
        SafetyTip(
            title: safetyTipEnable2FATitle,
            description: safetyTipEnable2FADesc),
        SafetyTip(
            title: safetyTipBewarePhishingTitle,
            description: safetyTipBewarePhishingDesc),
        SafetyTip(
            title: safetyTipRegularUpdatesTitle,
            description: safetyTipRegularUpdatesDesc),
      ]);

      isLoading.value = false;
    } catch (e) {
      error.value = 'Failed to load safety tips. Please try again.';
      isLoading.value = false;
    }
  }

  Future<void> refreshTips() async {
    await fetchSafetyTips();
  }
}