import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'register_screen.dart';
import 'registration_success_screen.dart';
import 'welcome_screen.dart';

/// Authentication flow wrapper that manages navigation between auth screens
class AuthWrapper extends StatefulWidget {
  final bool showOnboarding;
  final bool showWelcome;
  final VoidCallback onAuthSuccess;
  final VoidCallback? onWelcomeSeen;
  final VoidCallback? onOnboardingComplete;

  const AuthWrapper({
    super.key,
    required this.showOnboarding,
    required this.showWelcome,
    required this.onAuthSuccess,
    this.onWelcomeSeen,
    this.onOnboardingComplete,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late _AuthScreen _currentScreen;
  String? _registrationSuccessMessage;

  @override
  void initState() {
    super.initState();
    _currentScreen = _determineInitialScreen();
  }

  _AuthScreen _determineInitialScreen() {
    if (widget.showOnboarding) {
      return _AuthScreen.onboarding;
    } else if (widget.showWelcome) {
      return _AuthScreen.welcome;
    } else {
      return _AuthScreen.login;
    }
  }

  void _navigateTo(_AuthScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _markWelcomeSeenAndNavigate(_AuthScreen screen) {
    widget.onWelcomeSeen?.call();
    _navigateTo(screen);
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
          onComplete: () {
            widget.onOnboardingComplete?.call();
            _navigateTo(_AuthScreen.welcome);
          },
        );

      case _AuthScreen.welcome:
        return WelcomeScreen(
          key: const ValueKey('welcome'),
          onLoginTap: () => _markWelcomeSeenAndNavigate(_AuthScreen.login),
          onRegisterTap: () =>
              _markWelcomeSeenAndNavigate(_AuthScreen.register),
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
          onRegistered: (message) {
            setState(() {
              _registrationSuccessMessage = message;
              _currentScreen = _AuthScreen.registrationSuccess;
            });
          },
        );

      case _AuthScreen.registrationSuccess:
        return RegistrationSuccessScreen(
          key: const ValueKey('registration-success'),
          message: _registrationSuccessMessage ??
              'Your account has been created.',
          onSignInTap: () => _navigateTo(_AuthScreen.login),
        );
    }
  }
}

enum _AuthScreen {
  onboarding,
  welcome,
  login,
  register,
  registrationSuccess,
}
