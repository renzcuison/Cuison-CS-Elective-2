import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const AdaptiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
  });

  bool get _isIOS => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? action = isDisabled ? null : (onPressed ?? () {});

    if (_isIOS) {
      return CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        onPressed: action,
        child: Text(text),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
      onPressed: action,
      child: Text(text),
    );
  }
}