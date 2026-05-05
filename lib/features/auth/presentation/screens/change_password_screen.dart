import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';

/// Change password screen — accessible from the profile area.
/// Requires the user to supply their current password and choose a new one.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _oldPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).changePassword(
            _oldPasswordController.text,
            _newPasswordController.text,
          );

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
          ),
        );
        context.pop();
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
        title: const Text('Change Password'),
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

                Text(
                  'Update your password',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your new password must be different from your current password.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Current password
                PasswordTextField(
                  controller: _oldPasswordController,
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  textInputAction: TextInputAction.next,
                  focusNode: _oldPasswordFocusNode,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current password is required';
                    }
                    return null;
                  },
                  onSubmitted: (_) {
                    _newPasswordFocusNode.requestFocus();
                  },
                ),

                const SizedBox(height: AppSpacing.md),

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

                // Confirm new password
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
                  label: 'Change Password',
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
