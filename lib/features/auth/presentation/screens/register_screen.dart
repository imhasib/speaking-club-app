import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/auth_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/social_auth_button.dart';

/// Registration screen
class RegisterScreen extends ConsumerStatefulWidget {
  final VoidCallback onLoginTap;

  /// Called after Google sign-in completes (which authenticates immediately).
  /// Email/password registration does not issue a session — the user is
  /// routed to the login screen instead via [onLoginTap].
  final VoidCallback onSuccess;

  const RegisterScreen({
    super.key,
    required this.onLoginTap,
    required this.onSuccess,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String _fullPhoneNumber = '';
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          mobileNumber: _fullPhoneNumber,
          password: _passwordController.text,
        );

    if (!success || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created. Please log in to continue.'),
      ),
    );
    widget.onLoginTap();
  }

  Future<void> _googleLogin() async {
    setState(() => _isGoogleLoading = true);

    final success = await ref.read(authProvider.notifier).googleLogin();

    if (mounted) {
      setState(() => _isGoogleLoading = false);
      if (success) {
        widget.onSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final colorScheme = Theme.of(context).colorScheme;

    // Listen for auth errors
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenInsets,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),

                // Back button and header
                Row(
                  children: [
                    IconButton(
                      onPressed: isLoading ? null : widget.onLoginTap,
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Header
                Text(
                  'Create account',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Join Speaking Club and connect with people',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Google Sign In
                SocialAuthButton.google(
                  onPressed: _googleLogin,
                  isLoading: _isGoogleLoading,
                  enabled: !isLoading,
                ),

                const SizedBox(height: AppSpacing.lg),
                const OrDivider(text: 'or sign up with email'),
                const SizedBox(height: AppSpacing.lg),

                // Username field
                AuthTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Choose a unique username',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: Validators.validateUsername,
                  focusNode: _usernameFocusNode,
                  enabled: !isLoading,
                  maxLength: 30,
                  onSubmitted: (_) {
                    _emailFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Email field
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: Validators.validateEmail,
                  focusNode: _emailFocusNode,
                  enabled: !isLoading,
                  onSubmitted: (_) {
                    _phoneFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Phone field
                PhoneInputField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                  onChanged: (fullNumber) {
                    _fullPhoneNumber = fullNumber;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile number is required';
                    }
                    if (value.length < 6) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                  onSubmitted: (_) {
                    _passwordFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Password field
                PasswordTextField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  focusNode: _passwordFocusNode,
                  enabled: !isLoading,
                  showStrengthIndicator: true,
                  validator: Validators.validatePassword,
                  onSubmitted: (_) {
                    _confirmPasswordFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Confirm password field
                PasswordTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  textInputAction: TextInputAction.done,
                  focusNode: _confirmPasswordFocusNode,
                  enabled: !isLoading,
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  onSubmitted: (_) => _register(),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Register button
                AuthButton(
                  onPressed: _register,
                  label: 'Create Account',
                  isLoading: isLoading && !_isGoogleLoading,
                  enabled: !_isGoogleLoading,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Terms and conditions
                Text(
                  'By creating an account, you agree to our Terms of Service and Privacy Policy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : widget.onLoginTap,
                      child: const Text('Sign In'),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
