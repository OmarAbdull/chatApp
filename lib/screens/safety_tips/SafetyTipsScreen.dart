// safety_tips_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'SafetyTipsController.dart';

class SafetyTipsScreen extends StatelessWidget {


  SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SafetyTipsController controller = Get.put(SafetyTipsController(context));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Chat Safety Tips',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () => controller.refreshTips(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.tips.length,
            itemBuilder: (context, index) {
              final tip = controller.tips[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.security, color: Colors.blue),
                  title: Text(
                    tip.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      tip.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}