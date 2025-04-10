import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ProfileController.dart';

class ProfileName extends StatefulWidget {
  const ProfileName({super.key});

  @override
  State<ProfileName> createState() => _ProfileNameState();
}

class _ProfileNameState extends State<ProfileName> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  final ProfileController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _controller.name.value);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _saveName();
    }
  }

  void _saveName() {
    final newName = _textController.text.trim();
    if (newName.isNotEmpty && newName != _controller.name.value) {
      _controller.updateName(newName);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_textController.text != _controller.name.value) {
        _textController.text = _controller.name.value;
      }
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: const UnderlineInputBorder(),
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: 'Enter your name',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          onSubmitted: (value) => _focusNode.unfocus(),
        ),
      );
    });
  }
}