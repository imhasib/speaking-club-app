import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';

/// Reset password screen — accepts a `token` from the deep-link URL and lets
/// the user set a new password.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  /// The password-reset token extracted from the deep-link / push notification.
  final String token;

  /// Called after a successful reset so the caller can navigate to login.
  final VoidCallback onSuccess;

  const ResetPasswordScreen({
    super.key,
    required this.token,
    required this.onSuccess,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).resetPassword(
            widget.token,
            _newPasswordController.text,
          );

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully. Please sign in.'),
          ),
        );
        widget.onSuccess();
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
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenInsets,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),

                // Header
                Text(
                  'Reset password',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Choose a strong new password for your account.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // New password
                PasswordTextField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: 'Enter new password',
                  textInputAction: TextInputAction.next,
                  focusNode: _newPasswordFocusNode,
                  enabled: !_isLoading,
                  showStrengthIndicator: true,
                  validator: Validators.validatePassword,
                  onSubmitted: (_) {
                    _confirmPasswordFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Confirm password
                PasswordTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Re-enter new password',
                  textInputAction: TextInputAction.done,
                  focusNode: _confirmPasswordFocusNode,
                  enabled: !_isLoading,
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _newPasswordController.text,
                  ),
                  onSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: AppSpacing.xl),

                AuthButton(
                  onPressed: _submit,
                  label: 'Reset Password',
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
