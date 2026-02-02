import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../shared/providers/core_providers.dart';
import '../constants/app_constants.dart';
import 'routes.dart';

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  return AppRouter.createRouter(ref, authState);
});

/// App router configuration
class AppRouter {
  AppRouter._();

  static GoRouter createRouter(Ref ref, AuthState authState) {
    return GoRouter(
      initialLocation: Routes.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(ref),
      redirect: (context, state) async {
        final isAuthenticated = authState.isAuthenticated;
        final isLoading = authState is AuthStateInitial;
        final currentPath = state.uri.path;

        // Show splash while checking auth
        if (isLoading) {
          return Routes.splash;
        }

        // Once auth check is complete, redirect from splash
        if (currentPath == Routes.splash) {
          return isAuthenticated ? Routes.home : Routes.auth;
        }

        // Auth routes (excluding splash - handled above)
        final isAuthRoute = currentPath == Routes.auth ||
            currentPath == Routes.login ||
            currentPath == Routes.register;

        // If authenticated and on auth route, go to home
        if (isAuthenticated && isAuthRoute) {
          return Routes.home;
        }

        // If not authenticated and not on auth route, go to auth
        if (!isAuthenticated && !isAuthRoute) {
          return Routes.auth;
        }

        return null;
      },
      routes: [
        // Splash route
        GoRoute(
          path: Routes.splash,
          name: Routes.splashName,
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth routes
        GoRoute(
          path: Routes.auth,
          name: Routes.authName,
          builder: (context, state) => Consumer(
            builder: (context, ref, child) {
              return FutureBuilder<bool>(
                future: _checkOnboardingStatus(ref),
                builder: (context, snapshot) {
                  final showOnboarding = snapshot.data ?? true;
                  return AuthWrapper(
                    showOnboarding: showOnboarding,
                    onAuthSuccess: () {
                      context.go(Routes.home);
                    },
                  );
                },
              );
            },
          ),
        ),

        // Main app routes (placeholder for now)
        GoRoute(
          path: Routes.home,
          name: Routes.homeName,
          builder: (context, state) => const PlaceholderMainScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(state.uri.path),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(Routes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool> _checkOnboardingStatus(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    final completed = await storage.read(key: AppConstants.onboardingCompleteKey);
    return completed != 'true';
  }
}

/// Stream for GoRouter refresh
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref _ref;
}

/// Splash screen shown while checking auth status
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.record_voice_over_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Spoken Club',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Placeholder main screen until proper home is implemented
class PlaceholderMainScreen extends ConsumerWidget {
  const PlaceholderMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spoken Club'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 80,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome, ${user?.username ?? 'User'}!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You are now authenticated',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              if (user != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(label: 'Email', value: user.email),
                        const Divider(),
                        _InfoRow(label: 'Mobile', value: user.mobileNumber),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 48),
              Text(
                'Home screen and other features will be implemented in the next phase.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
