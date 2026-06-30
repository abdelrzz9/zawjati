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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.unfocus();
    context.read<AuthBloc>().add(
          LoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.background,
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
                        _buildEmailField(),
                        SizedBox(height: AppThemeMetrics.spacingMd),
                        _buildPasswordField(),
                        SizedBox(height: AppThemeMetrics.spacingSm),
                        _buildForgotPassword(context),
                        SizedBox(height: AppThemeMetrics.spacingLg),
                        _buildLoginButton(state),
                        SizedBox(height: AppThemeMetrics.spacingXl),
                        _buildDivider(),
                        SizedBox(height: AppThemeMetrics.spacingLg),
                        _buildSocialButtons(),
                        SizedBox(height: AppThemeMetrics.spacingXl),
                        _buildSignUpLink(context),
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
          'Welcome Back',
          style: context.textTheme.headlineMedium?.copyWith(
            color: AppThemeColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeMetrics.spacingSm),
        Text(
          'Sign in to continue with Zawjati',
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
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onLogin(),
      style: TextStyle(color: AppThemeColors.primaryText),
      decoration: _inputDecoration(
        label: 'Password',
        hint: 'Enter your password',
        icon: Icons.lock_outlined,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppThemeColors.hintText,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: AppValidators.validatePassword,
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.go(AppRoutes.forgotPassword),
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: AppThemeColors.primaryAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthState state) {
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
          onPressed: isLoading ? null : _onLogin,
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
                  'Sign In',
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppThemeColors.divider)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppThemeMetrics.spacingMd),
          child: Text(
            'OR',
            style: TextStyle(
              color: AppThemeColors.hintText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppThemeColors.divider)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        _socialButton(
          icon: Icons.g_mobiledata_rounded,
          label: 'Continue with Google',
          color: AppThemeColors.google,
          onPressed: () {},
        ),
        SizedBox(height: AppThemeMetrics.spacingSm),
        _socialButton(
          icon: Icons.apple_rounded,
          label: 'Continue with Apple',
          color: AppThemeColors.primaryText,
          onPressed: () {},
        ),
        SizedBox(height: AppThemeMetrics.spacingSm),
        _socialButton(
          icon: Icons.code_rounded,
          label: 'Continue with GitHub',
          color: AppThemeColors.neutral200,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 22),
        label: Text(
          label,
          style: TextStyle(
            color: AppThemeColors.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppThemeColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: AppThemeColors.secondaryText),
        ),
        TextButton(
          onPressed: () => context.go(AppRoutes.register),
          child: Text(
            'Create Account',
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
        color: AppThemeColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
        border: Border.all(
          color: AppThemeColors.error.withValues(alpha: 0.3),
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
      hintStyle: TextStyle(color: AppThemeColors.hintText.withValues(alpha: 0.6)),
    );
  }
}
