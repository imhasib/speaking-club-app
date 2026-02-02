import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/auth_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';

/// Login screen
class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onSuccess;

  const LoginScreen({
    super.key,
    required this.onRegisterTap,
    required this.onSuccess,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      widget.onSuccess();
    }
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
                const SizedBox(height: AppSpacing.xxl),

                // Header
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign in to continue to Speaking Club',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Google Sign In
                SocialAuthButton.google(
                  onPressed: _googleLogin,
                  isLoading: _isGoogleLoading,
                  enabled: !isLoading,
                ),

                const SizedBox(height: AppSpacing.lg),
                const OrDivider(),
                const SizedBox(height: AppSpacing.lg),

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
                    _passwordFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Password field
                PasswordTextField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  onSubmitted: (_) => _login(),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            // TODO: Implement forgot password (Phase 2)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Forgot password will be available soon'),
                              ),
                            );
                          },
                    child: const Text('Forgot password?'),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Login button
                AuthButton(
                  onPressed: _login,
                  label: 'Sign In',
                  isLoading: isLoading && !_isGoogleLoading,
                  enabled: !_isGoogleLoading,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : widget.onRegisterTap,
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
