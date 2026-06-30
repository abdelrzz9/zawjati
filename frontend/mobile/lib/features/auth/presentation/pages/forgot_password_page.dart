import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zawjati_mobile/core/extensions/context_extensions.dart';
import 'package:zawjati_mobile/core/extensions/responsive_extensions.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/core/validators/validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.unfocus();
    setState(() => _isSubmitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppThemeColors.primaryText,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.hPadding(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.cardMaxWidth()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  SizedBox(height: context.sectionSpacing() * 3),
                  if (_isSubmitted)
                    _buildSuccessView()
                  else
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildEmailField(),
                          SizedBox(height: AppThemeMetrics.spacingLg),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.lock_reset_rounded,
          size: context.logoSize(),
          color: AppThemeColors.primaryAccent,
        ),
        SizedBox(height: AppThemeMetrics.spacingLg),
        Text(
          'Forgot Password',
          style: context.textTheme.headlineMedium?.copyWith(
            color: AppThemeColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeMetrics.spacingSm),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppThemeColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onSubmit(),
      style: TextStyle(color: AppThemeColors.primaryText),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email_outlined, color: AppThemeColors.hintText),
        filled: true,
        fillColor: AppThemeColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          borderSide: BorderSide(color: AppThemeColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          borderSide: BorderSide(color: AppThemeColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          borderSide: BorderSide(
            color: AppThemeColors.primaryAccent,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          borderSide: BorderSide(color: AppThemeColors.error),
        ),
        labelStyle: TextStyle(color: AppThemeColors.hintText),
        hintStyle: TextStyle(color: AppThemeColors.hintText.withValues(alpha: 0.6)),
      ),
      validator: AppValidators.validateEmail,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          gradient: const LinearGradient(
            colors: [
              AppThemeColors.gradientAccentStart,
              AppThemeColors.gradientAccentEnd,
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
            ),
          ),
          child: Text(
            'Send Reset Link',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppThemeColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 80,
          color: AppThemeColors.success,
        ),
        SizedBox(height: AppThemeMetrics.spacingLg),
        Text(
          'Check Your Email',
          style: context.textTheme.titleLarge?.copyWith(
            color: AppThemeColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeMetrics.spacingSm),
        Text(
          'If an account exists with ${_emailController.text.trim()}, we\'ve sent a password reset link.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppThemeColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeMetrics.spacingXl),
        SizedBox(
          height: 52,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppThemeColors.primaryAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
              ),
            ),
            child: Text(
              'Back to Sign In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppThemeColors.primaryAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
