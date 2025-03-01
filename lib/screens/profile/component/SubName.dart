
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../ProfileController.dart';

class SubName extends StatelessWidget {
  const SubName({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();
    return Obx(
          () => Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Text(
          controller.subTitle.value,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}