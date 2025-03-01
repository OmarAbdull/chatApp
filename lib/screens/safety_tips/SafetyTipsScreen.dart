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
      appBar: AppBar(
        title: const Text('Chat Safety Tips'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.fetchSafetyTips(),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

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