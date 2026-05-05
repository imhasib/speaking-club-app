import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void _reportError(Object error, StackTrace stack) {
  // TODO(C3): Replace with FirebaseCrashlytics.instance.recordError(error, stack)
  //           once Firebase is initialised.
  debugPrint('ERROR: $error\n$stack');
}

void main() {
  // Flutter framework errors (widget build failures, rendering issues)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    _reportError(details.exception, details.stack ?? StackTrace.empty);
  };

  // Dart async errors that escape all zones (platform channel errors etc.)
  PlatformDispatcher.instance.onError = (error, stack) {
    _reportError(error, stack);
    return true;
  };

  runZonedGuarded(
    () async {
      // ensureInitialized must be called in the same zone as runApp
      WidgetsFlutterBinding.ensureInitialized();

      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );

      runApp(
        const ProviderScope(
          child: SpeakingClubApp(),
        ),
      );
    },
    _reportError,
  );
}

/// Main application widget
class SpeakingClubApp extends ConsumerWidget {
  const SpeakingClubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Speaking Club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
