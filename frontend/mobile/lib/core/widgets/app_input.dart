import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final String? error;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscure;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const ZawjatiTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.error,
    this.prefixIcon,
    this.suffixIcon,
    this.obscure = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<ZawjatiTextField> createState() => _ZawjatiTextFieldState();
}

class _ZawjatiTextFieldState extends State<ZawjatiTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscured = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscured = widget.obscure;
    _error = widget.error;

    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });

    _controller.addListener(() {
      if (_error != null) {
        setState(() => _error = null);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final hasError = _error != null && _error!.isNotEmpty;

    final borderColor = hasError
        ? AppThemeColors.error
        : isFocused
            ? AppThemeColors.primaryAccent
            : AppThemeColors.inputBorder;

    final borderWidth = hasError || isFocused
        ? AppThemeMetrics.borderFocus
        : AppThemeMetrics.borderThin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppThemeMetrics.spacingSm),
            child: Text(
              widget.label!,
              style: AppThemeTextStyles.inputLabelStyle,
            ),
          ),
        ],
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
            color: widget.enabled
                ? AppThemeColors.primaryText
                : AppThemeColors.hintText,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppThemeTextStyles.inputHintStyle,
            errorText: null,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : widget.suffixIcon,
            filled: true,
            fillColor: widget.enabled
                ? AppThemeColors.inputFill
                : AppThemeColors.inputFill.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
              borderSide: BorderSide(color: borderColor, width: borderWidth),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
              borderSide: BorderSide(color: AppThemeColors.inputBorder, width: AppThemeMetrics.borderThin),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
              borderSide: BorderSide(
                color: hasError ? AppThemeColors.error : AppThemeColors.primaryAccent,
                width: AppThemeMetrics.borderFocus,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
              borderSide: BorderSide(color: AppThemeColors.error, width: AppThemeMetrics.borderThin),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
              borderSide: BorderSide(color: AppThemeColors.error, width: AppThemeMetrics.borderFocus),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppThemeMetrics.spacingMd,
              vertical: AppThemeMetrics.spacingMd,
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppThemeMetrics.spacingXs),
          Padding(
            padding: const EdgeInsets.only(left: AppThemeMetrics.spacingSm),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 14, color: AppThemeColors.error),
                const SizedBox(width: 4),
                Text(
                  _error!,
                  style: AppThemeTextStyles.textTheme.labelSmall?.copyWith(
                    color: AppThemeColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class ZawjatiSearchField extends StatelessWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;

  const ZawjatiSearchField({
    super.key,
    this.hint = 'Search...',
    this.onChanged,
    this.onClear,
    this.controller,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return ZawjatiTextField(
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.search_rounded, size: 20),
      suffixIcon: _SearchClearButton(
        controller: controller,
        onClear: onClear,
      ),
    );
  }
}

class _SearchClearButton extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onClear;

  const _SearchClearButton({this.controller, this.onClear});

  @override
  State<_SearchClearButton> createState() => _SearchClearButtonState();
}

class _SearchClearButtonState extends State<_SearchClearButton> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.text.isEmpty) return const SizedBox.shrink();
    return IconButton(
      icon: const Icon(Icons.close_rounded, size: 18),
      onPressed: () {
        _controller.clear();
        widget.onClear?.call();
      },
      splashRadius: 18,
    );
  }
}
