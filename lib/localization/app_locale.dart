import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';

mixin AppLocale {
  static const String title = 'title';
  static const String chat = 'chat';
  static const String darkTheme = 'Dark Theme';
  static const String lightTheme = 'Light Theme';
  static const String login = 'Login';
  static const String signup = 'Signup';
  static const String systemTheme = 'System Theme';
  static const String phoneNumber = 'Phone Number';
  static const String userName = 'Username';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String email = 'email';
  static const String enterPassword = 'Please enter your password';
  static const String enterUsername = 'Please enter your the username';
  static const String enterPhoneNumber = 'Please enter your phone number';
  static const String passwordLength = 'Password must be at least 6 characters';
  static const String loginFailed = 'Login Failed';
  static const String invalidCredentials = 'Invalid credentials';
  static const String invalidPhoneFormat = 'Invalid number. Format: 77, 78, 73,71,70';
  static const String enterConfirmPassword = 'Please confirm your password';
  static const String matchPassword = 'Passwords do not match';
  static const String emailNotValid = 'Enter a valid email address';
  static const String enterEmail = 'Email is required';
  static const String yes = 'Yes';
  static const String no = 'No';

  // Add SafetyTip keys
  static const String safetyTipKeepInfoPrivateTitle = 'safetyTipKeepInfoPrivateTitle';
  static const String safetyTipKeepInfoPrivateDesc = 'safetyTipKeepInfoPrivateDesc';
  static const String safetyTipVerifyContactsTitle = 'safetyTipVerifyContactsTitle';
  static const String safetyTipVerifyContactsDesc = 'safetyTipVerifyContactsDesc';
  static const String safetyTipUseStrongPasswordsTitle = 'safetyTipUseStrongPasswordsTitle';
  static const String safetyTipUseStrongPasswordsDesc = 'safetyTipUseStrongPasswordsDesc';
  static const String safetyTipEnable2FATitle = 'safetyTipEnable2FATitle';
  static const String safetyTipEnable2FADesc = 'safetyTipEnable2FADesc';
  static const String safetyTipBewarePhishingTitle = 'safetyTipBewarePhishingTitle';
  static const String safetyTipBewarePhishingDesc = 'safetyTipBewarePhishingDesc';
  static const String safetyTipRegularUpdatesTitle = 'safetyTipRegularUpdatesTitle';
  static const String safetyTipRegularUpdatesDesc = 'safetyTipRegularUpdatesDesc';

  static const String pickContacts = 'PickFromContacts';

  static const Map<String, String> EN = {
    title: 'Settings',
    darkTheme: 'Dark Theme',
    lightTheme: 'Light Theme',
    systemTheme: 'System Theme',
    login: 'Login',
    phoneNumber: 'Phone Number',
    password: 'Password',
    enterPassword: 'Please enter your password',
    passwordLength: 'Password must be at least 6 characters',
    loginFailed: 'Login Failed',
    invalidPhoneFormat: 'Invalid number. Format: 77, 78, 73,71,70',
    invalidCredentials: 'Invalid credentials',
    enterPhoneNumber: 'Please enter your phone number',
    signup: 'Signup',
    email: 'email',
    userName: 'Username',
    confirmPassword: 'Confirm Password',
    enterUsername: 'Please enter your the username',
    enterConfirmPassword: 'Please confirm your password',
    matchPassword: 'Passwords do not match',
    enterEmail: 'Email is required',
    emailNotValid: 'Enter a valid email address',
    yes: "Yes",
    no: "No",

    // Add SafetyTip translations
    safetyTipKeepInfoPrivateTitle: 'Keep Personal Information Private',
    safetyTipKeepInfoPrivateDesc: 'Never share your password, address, or financial details with strangers in the chat.',
    safetyTipVerifyContactsTitle: 'Verify Unknown Contacts',
    safetyTipVerifyContactsDesc: 'Always confirm the identity of new contacts before sharing sensitive information.',
    safetyTipUseStrongPasswordsTitle: 'Use Strong Passwords',
    safetyTipUseStrongPasswordsDesc: 'Create complex passwords and change them regularly. Consider using a password manager.',
    safetyTipEnable2FATitle: 'Enable Two-Factor Authentication',
    safetyTipEnable2FADesc: 'Add an extra layer of security to your account with 2FA.',
    safetyTipBewarePhishingTitle: 'Beware of Phishing Links',
    safetyTipBewarePhishingDesc: 'Don\'t click on suspicious links sent through chat messages.',
    safetyTipRegularUpdatesTitle: 'Regular App Updates',
    safetyTipRegularUpdatesDesc: 'Keep the app updated to benefit from the latest security patches.',
    chat : "Chat",
    pickContacts : "Pick from Contacts",
  };

  static const Map<String, String> AR = {
    title: 'الإعدادات',
    darkTheme: 'الوضع المظلم',
    lightTheme: 'الوضع الفاتح',
    systemTheme: 'النظام الافتراضي',
    login: 'تسجيل الدخول',
    phoneNumber: 'رقم الهاتف',
    password: 'الرمز السري',
    enterPassword: 'أدخل كلمة المرور',
    passwordLength: 'يحب الا يقل الرمز عن 6 أحرف',
    loginFailed: 'فشل تسجيل الدخول',
    invalidPhoneFormat: 'رقم غير صحيح. التنسيق: 77,78,73,71,70.',
    invalidCredentials: 'بيانات الاعتماد غير صالحة',
    enterPhoneNumber: 'أدخل رقم الهاتف',
    signup: 'إنشاء حساب',
    email: 'الإميل',
    userName: 'أسم المستخدم',
    confirmPassword: 'تأكيد كلمة المرور',
    enterUsername: 'الرجاء إدخال إسم المستخدم',
    enterConfirmPassword: 'الرجاء تأكيد كلمة المرور ',
    matchPassword: 'كلمة المرور غير متطابقة ',
    enterEmail: 'الرجاء إدخال الإيميل ',
    emailNotValid: 'الإميل غير صحيح',
    yes: "نعم",
    no: "لا",

    // Add SafetyTip translations in Arabic
    safetyTipKeepInfoPrivateTitle: 'حافظ على خصوصية معلوماتك الشخصية',
    safetyTipKeepInfoPrivateDesc: 'لا تشارك كلمة المرور أو العنوان أو التفاصيل المالية مع الغرباء في الدردشة.',
    safetyTipVerifyContactsTitle: 'تحقق من جهات الاتصال المجهولة',
    safetyTipVerifyContactsDesc: 'قم دائمًا بتأكيد هوية جهات الاتصال الجديدة قبل مشاركة المعلومات الحساسة.',
    safetyTipUseStrongPasswordsTitle: 'استخدم كلمات مرور قوية',
    safetyTipUseStrongPasswordsDesc: 'أنشئ كلمات مرور معقدة وغيرها بانتظام. فكر في استخدام مدير كلمات المرور.',
    safetyTipEnable2FATitle: 'تفعيل المصادقة الثنائية',
    safetyTipEnable2FADesc: 'أضف طبقة أمان إضافية إلى حسابك باستخدام المصادقة الثنائية.',
    safetyTipBewarePhishingTitle: 'احذر من روابط التصيد',
    safetyTipBewarePhishingDesc: 'لا تنقر على الروابط المشبوهة المرسلة عبر رسائل الدردشة.',
    safetyTipRegularUpdatesTitle: 'تحديثات التطبيق المنتظمة',
    safetyTipRegularUpdatesDesc: 'حافظ على تحديث التطبيق للاستفادة من أحدث تصحيحات الأمان.',

    chat : "المراسلات",
    pickContacts : "أختر من جهات الإتصال",

  };

  static String getString(BuildContext context, String key) {
    final flutterLocalization = FlutterLocalization.instance;
    final currentLocale = flutterLocalization.currentLocale?.languageCode ?? 'en';
    // Access the correct translation map based on current locale
    final translations = currentLocale == 'ar' ? AR : EN;

    // Return the translated string or key as fallback
    return translations[key] ?? key;
  }
}