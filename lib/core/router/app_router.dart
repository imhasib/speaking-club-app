import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_practice/presentation/screens/ai_history_screen.dart';
import '../../features/ai_practice/presentation/screens/ai_session_detail_screen.dart';
import '../../features/ai_practice/presentation/screens/ai_session_screen.dart';
import '../../features/ai_practice/presentation/screens/ai_summary_screen.dart';
import '../../features/ai_practice/presentation/screens/mode_selection_screen.dart';
import '../../features/auth/auth.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/call/call.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../shared/providers/core_providers.dart';
import '../../shared/widgets/animations/page_transitions.dart';
import '../constants/app_constants.dart';
import 'main_scaffold.dart';
import 'routes.dart';

/// App router provider - creates router once and uses refresh for updates
final appRouterProvider = Provider<GoRouter>((ref) {
  // Don't watch authProvider here - that would recreate the router on every change
  // Instead, read auth state in redirect callback
  return AppRouter.createRouter(ref);
});

/// App router configuration
class AppRouter {
  AppRouter._();

  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: Routes.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(ref),
      redirect: (context, state) async {
        // Read auth state here (not watched, just current value)
        final authState = ref.read(authProvider);
        final isAuthenticated = authState.isAuthenticated;
        final isLoading = authState is AuthStateInitial;
        final isError = authState is AuthStateError;
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

        // Protected routes (require authentication)
        final isProtectedRoute = currentPath == Routes.home ||
            currentPath == Routes.history ||
            currentPath == Routes.profile ||
            currentPath == Routes.waiting ||
            currentPath == Routes.call ||
            currentPath == Routes.incomingCall ||
            currentPath == Routes.aiPractice ||
            currentPath == Routes.aiSession ||
            currentPath == Routes.aiSummary ||
            currentPath == Routes.aiHistory ||
            currentPath.startsWith('/ai-practice/sessions/');

        // If authenticated and on auth route, go to home
        if (isAuthenticated && isAuthRoute) {
          return Routes.home;
        }

        // Don't redirect on error - let the user see the error on current screen
        if (isError && isAuthRoute) {
          return null;
        }

        // If not authenticated and on protected route, go to auth
        if (!isAuthenticated && isProtectedRoute) {
          return Routes.auth;
        }

        // If not authenticated and not on auth route or protected route, go to auth
        if (!isAuthenticated && !isAuthRoute && !isProtectedRoute) {
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
              return FutureBuilder<({bool showOnboarding, bool showWelcome})>(
                future: _checkInitialScreenStatus(ref),
                builder: (context, snapshot) {
                  // Show loading while checking storage
                  if (!snapshot.hasData) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final status = snapshot.data!;
                  return AuthWrapper(
                    showOnboarding: status.showOnboarding,
                    showWelcome: status.showWelcome,
                    onAuthSuccess: () {
                      context.go(Routes.home);
                    },
                    onOnboardingComplete: () {
                      _markOnboardingComplete(ref);
                    },
                    onWelcomeSeen: () {
                      _markWelcomeSeen(ref);
                    },
                  );
                },
              );
            },
          ),
        ),

        // Call routes (full-screen, outside bottom navigation)
        GoRoute(
          path: Routes.waiting,
          name: Routes.waitingName,
          pageBuilder: (context, state) => buildPageWithTransition(
            context: context,
            state: state,
            child: const WaitingScreen(),
            type: PageTransitionType.slideUp,
            duration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: Routes.call,
          name: Routes.callName,
          pageBuilder: (context, state) => buildPageWithTransition(
            context: context,
            state: state,
            child: const CallScreen(),
            type: PageTransitionType.fadeScale,
            duration: const Duration(milliseconds: 400),
          ),
        ),
        GoRoute(
          path: Routes.incomingCall,
          name: Routes.incomingCallName,
          pageBuilder: (context, state) => buildPageWithTransition(
            context: context,
            state: state,
            child: const IncomingCallScreen(),
            type: PageTransitionType.slideUp,
            duration: const Duration(milliseconds: 300),
          ),
        ),

        // AI Practice routes
        GoRoute(
          path: Routes.aiPractice,
          name: Routes.aiPracticeName,
          pageBuilder: (context, state) => buildPageWithTransition(
            context: context,
            state: state,
            child: const ModeSelectionScreen(),
            type: PageTransitionType.slideUp,
            duration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: Routes.aiSession,
          name: Routes.aiSessionName,
          pageBuilder: (context, state) => buildPageWithTransition(
            context: context,
            state: state,
            child: const AiSessionScreen(),
            type: PageTransitionType.fadeScale,
            duration: const Duration(milliseconds: 400),
          ),
        ),
        GoRoute(
          path: Routes.aiSummary,
          name: Routes.aiSummaryName,
          builder: (context, state) => const AiSummaryScreen(),
        ),
        GoRoute(
          path: Routes.aiHistory,
          name: Routes.aiHistoryName,
          pageBuilder: (context, state) => buildPageWithTransition(
            context: context,
            state: state,
            child: const AiHistoryScreen(),
            type: PageTransitionType.slideUp,
            duration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: Routes.aiSessionDetail,
          name: Routes.aiSessionDetailName,
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            return AiSessionDetailScreen(sessionId: sessionId);
          },
        ),

        // Main app routes with bottom navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScaffold(navigationShell: navigationShell);
          },
          branches: [
            // Home branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.home,
                  name: Routes.homeName,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            // History branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.history,
                  name: Routes.historyName,
                  builder: (context, state) => const HistoryScreen(),
                ),
              ],
            ),
            // Profile branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.profile,
                  name: Routes.profileName,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
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

  static Future<({bool showOnboarding, bool showWelcome})>
      _checkInitialScreenStatus(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    final onboardingComplete =
        await storage.read(key: AppConstants.onboardingCompleteKey);
    final welcomeSeen = await storage.read(key: AppConstants.welcomeSeenKey);
    return (
      showOnboarding: onboardingComplete != 'true',
      showWelcome: welcomeSeen != 'true',
    );
  }

  static Future<void> _markOnboardingComplete(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: AppConstants.onboardingCompleteKey, value: 'true');
  }

  static Future<void> _markWelcomeSeen(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: AppConstants.welcomeSeenKey, value: 'true');
    // Also mark onboarding as complete when welcome is seen
    await storage.write(key: AppConstants.onboardingCompleteKey, value: 'true');
  }
}

/// Stream for GoRouter refresh
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      // Only refresh router when authentication status actually changes
      // Don't refresh on error or loading states to preserve navigation state
      final wasAuthenticated = previous?.isAuthenticated ?? false;
      final isAuthenticated = next.isAuthenticated;
      final wasInitial = previous is AuthStateInitial || previous == null;
      final isInitial = next is AuthStateInitial;

      // Refresh only when:
      // 1. Moving from initial state to a resolved state
      // 2. Authentication status changes (logged in <-> logged out)
      if ((wasInitial && !isInitial) ||
          (wasAuthenticated != isAuthenticated)) {
        notifyListeners();
      }
    });
  }

  final Ref _ref;
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
        title: const Text('Speaking Club'),
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
                'Welcome, ${user?.name ?? 'User'}!',
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
                        _InfoRow(label: 'Mobile', value: user.mobileNumber ?? "No mobile number"),
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
