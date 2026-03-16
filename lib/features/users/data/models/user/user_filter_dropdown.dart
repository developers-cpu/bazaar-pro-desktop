import 'package:flutter/material.dart';
class UserFilterDropdown {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const UserFilterDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });
}
