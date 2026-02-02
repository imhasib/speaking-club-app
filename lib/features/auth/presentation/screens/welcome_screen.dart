import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/auth_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_auth_button.dart';

/// Welcome screen with sign up/login options
class WelcomeScreen extends ConsumerStatefulWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;
  final VoidCallback onSuccess;

  const WelcomeScreen({
    super.key,
    required this.onLoginTap,
    required this.onRegisterTap,
    required this.onSuccess,
  });

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isGoogleLoading = false;

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
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: Column(
            children: [
              const Spacer(),

              // Logo and branding
              Icon(
                Icons.record_voice_over_rounded,
                size: 100,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Spoken Club',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Connect through voice & video',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),

              const Spacer(),

              // Auth buttons
              SocialAuthButton.google(
                onPressed: _googleLogin,
                isLoading: _isGoogleLoading,
                enabled: !isLoading,
              ),

              const SizedBox(height: AppSpacing.md),

              const OrDivider(),

              const SizedBox(height: AppSpacing.md),

              // Sign Up button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: isLoading ? null : widget.onRegisterTap,
                  child: const Text('Create Account'),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: isLoading ? null : widget.onLoginTap,
                  child: const Text('Sign In'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Terms
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
