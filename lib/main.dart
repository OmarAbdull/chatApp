import 'package:chat_app/modle/database/App_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'MyApp.dart';
import 'MyAppController.dart';
Future<void> main() async {
  await dotenv.load(fileName: ".env");  // Load .env file
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  Get.put(AppDatabase());
  Get.put(MyAppController());
  runApp(const MyApp());
}