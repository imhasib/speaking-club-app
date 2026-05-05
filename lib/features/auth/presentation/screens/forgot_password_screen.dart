import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';

/// Forgot password screen — collects the user's email and triggers the
/// password-reset email flow via the user-service.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  /// Called when the user taps "Back to Sign In".
  final VoidCallback onBackToLogin;

  const ForgotPasswordScreen({
    super.key,
    required this.onBackToLogin,
  });

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .forgotPassword(_emailController.text.trim());

      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Back button
              Row(
                children: [
                  IconButton(
                    onPressed: _isLoading ? null : widget.onBackToLogin,
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              if (_emailSent) ...[
                _SuccessContent(onBackToLogin: widget.onBackToLogin),
              ] else ...[
                // Header
                Text(
                  'Forgot password?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Enter your email address and we will send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Email form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: Validators.validateEmail,
                        focusNode: _emailFocusNode,
                        enabled: !_isLoading,
                        onSubmitted: (_) => _submit(),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      AuthButton(
                        onPressed: _submit,
                        label: 'Send Reset Link',
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Back to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : widget.onBackToLogin,
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown after a successful forgot-password submission.
class _SuccessContent extends StatelessWidget {
  final VoidCallback onBackToLogin;

  const _SuccessContent({required this.onBackToLogin});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success icon
        Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_outlined,
              size: 56,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Text(
          'Check your email',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'If your email address is registered with Speaking Club, you will receive a password reset link shortly.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),

        const SizedBox(height: AppSpacing.xxl),

        AuthButton(
          onPressed: onBackToLogin,
          label: 'Back to Sign In',
          icon: Icons.arrow_back,
        ),
      ],
    );
  }
}
