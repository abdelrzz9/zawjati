import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zawjati_mobile/core/router/app_routes.dart';
import 'package:zawjati_mobile/core/extensions/context_extensions.dart';
import 'package:zawjati_mobile/core/extensions/responsive_extensions.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/core/validators/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    context.unfocus();
    context.read<AuthBloc>().add(
          RegisterRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          ),
        );
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
              child: Form(
                key: _formKey,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      context.go(AppRoutes.home);
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),
                        SizedBox(height: context.sectionSpacing() * 3),
                        if (state is AuthError)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: AppThemeMetrics.spacingMd,
                            ),
                            child: _buildErrorBanner(state.message),
                          ),
                        _buildNameField(),
                        SizedBox(height: AppThemeMetrics.spacingMd),
                        _buildEmailField(),
                        SizedBox(height: AppThemeMetrics.spacingMd),
                        _buildPasswordField(),
                        SizedBox(height: AppThemeMetrics.spacingMd),
                        _buildConfirmPasswordField(),
                        SizedBox(height: AppThemeMetrics.spacingLg),
                        _buildRegisterButton(state),
                        SizedBox(height: AppThemeMetrics.spacingXl),
                        _buildLoginLink(context),
                      ],
                    );
                  },
                ),
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
          Icons.favorite_rounded,
          size: context.logoSize(),
          color: AppThemeColors.primaryAccent,
        ),
        SizedBox(height: AppThemeMetrics.spacingLg),
        Text(
          'Create Account',
          style: context.textTheme.headlineMedium?.copyWith(
            color: AppThemeColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeMetrics.spacingSm),
        Text(
          'Join Zawjati and start your journey',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppThemeColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(color: AppThemeColors.primaryText),
      decoration: _inputDecoration(
        label: 'Full Name',
        hint: 'Enter your name',
        icon: Icons.person_outlined,
      ),
      validator: (v) => AppValidators.validateRequired(v, fieldName: 'Name'),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: AppThemeColors.primaryText),
      decoration: _inputDecoration(
        label: 'Email',
        hint: 'Enter your email',
        icon: Icons.email_outlined,
      ),
      validator: AppValidators.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: AppThemeColors.primaryText),
      decoration: _inputDecoration(
        label: 'Password',
        hint: 'Create a strong password',
        icon: Icons.lock_outlined,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppThemeColors.hintText,
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: AppValidators.validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onRegister(),
      style: TextStyle(color: AppThemeColors.primaryText),
      decoration: _inputDecoration(
        label: 'Confirm Password',
        hint: 'Re-enter your password',
        icon: Icons.lock_outlined,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppThemeColors.hintText,
          ),
          onPressed: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ),
      validator: (v) => AppValidators.validateConfirmPassword(
        v,
        password: _passwordController.text,
      ),
    );
  }

  Widget _buildRegisterButton(AuthState state) {
    final isLoading = state is AuthLoading;
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
          onPressed: isLoading ? null : _onRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppThemeColors.primaryText,
                  ),
                )
              : Text(
                  'Create Account',
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

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: AppThemeColors.secondaryText),
        ),
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: AppThemeColors.primaryAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: EdgeInsets.all(AppThemeMetrics.spacingMd),
      decoration: BoxDecoration(
        color: AppThemeColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
        border: Border.all(
          color: AppThemeColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppThemeColors.error, size: 20),
          SizedBox(width: AppThemeMetrics.spacingSm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppThemeColors.error,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppThemeColors.hintText),
      suffixIcon: suffixIcon,
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
      hintStyle: TextStyle(color: AppThemeColors.hintText.withOpacity(0.6)),
    );
  }
}
