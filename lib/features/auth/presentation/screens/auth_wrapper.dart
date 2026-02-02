import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'register_screen.dart';
import 'welcome_screen.dart';

/// Authentication flow wrapper that manages navigation between auth screens
class AuthWrapper extends StatefulWidget {
  final bool showOnboarding;
  final VoidCallback onAuthSuccess;

  const AuthWrapper({
    super.key,
    required this.showOnboarding,
    required this.onAuthSuccess,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late _AuthScreen _currentScreen;

  @override
  void initState() {
    super.initState();
    _currentScreen =
        widget.showOnboarding ? _AuthScreen.onboarding : _AuthScreen.welcome;
  }

  void _navigateTo(_AuthScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case _AuthScreen.onboarding:
        return OnboardingScreen(
          key: const ValueKey('onboarding'),
          onComplete: () => _navigateTo(_AuthScreen.welcome),
        );

      case _AuthScreen.welcome:
        return WelcomeScreen(
          key: const ValueKey('welcome'),
          onLoginTap: () => _navigateTo(_AuthScreen.login),
          onRegisterTap: () => _navigateTo(_AuthScreen.register),
          onSuccess: widget.onAuthSuccess,
        );

      case _AuthScreen.login:
        return LoginScreen(
          key: const ValueKey('login'),
          onRegisterTap: () => _navigateTo(_AuthScreen.register),
          onSuccess: widget.onAuthSuccess,
        );

      case _AuthScreen.register:
        return RegisterScreen(
          key: const ValueKey('register'),
          onLoginTap: () => _navigateTo(_AuthScreen.login),
          onSuccess: widget.onAuthSuccess,
        );
    }
  }
}

enum _AuthScreen {
  onboarding,
  welcome,
  login,
  register,
}
