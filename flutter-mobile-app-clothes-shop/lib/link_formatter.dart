import 'package:flutter/services.dart';

class LinkInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final regex = RegExp(r'^https://.*');
    if (regex.hasMatch(newText)) {
      return newValue;
    }
    return oldValue;
  }
}