import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';

class MemorySearchBar extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const MemorySearchBar({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: initialValue != null
          ? TextEditingController(text: initialValue)
          : null,
      onChanged: onChanged,
      style: const TextStyle(color: AppThemeColors.primaryText),
      decoration: InputDecoration(
        hintText: 'Search memories...',
        hintStyle: const TextStyle(color: AppThemeColors.hintText),
        prefixIcon:
            const Icon(Icons.search, color: AppThemeColors.neutral300),
        suffixIcon: onClear != null
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppThemeColors.neutral300),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: AppThemeColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppThemeColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppThemeColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppThemeColors.primaryAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
