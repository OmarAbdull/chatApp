import 'package:chat_app/modle/database/App_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'MyApp.dart';
import 'MyAppController.dart';
import 'modle/NotificationHelper.dart';
Future<void> main() async {
  await dotenv.load(fileName: ".env");  // Load .env file
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  await FlutterLocalization.instance.ensureInitialized();
  final appDatabase = AppDatabase();
  appDatabase.insertOrUpdateChat(id: 0, senderName: "senderName", userKey: "userKey", avatarBase64: "avatarBase64");
  appDatabase.deleteChat(0);
  Get.put(AppDatabase());
  Get.put(MyAppController());
  runApp(const MyApp());
}