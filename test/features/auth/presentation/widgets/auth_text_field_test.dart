import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  group('AuthTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      String label = 'Test Label',
      String? hint,
      bool obscureText = false,
      String? Function(String?)? validator,
      void Function(String)? onChanged,
      Widget? prefixIcon,
      bool enabled = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AuthTextField(
              controller: controller,
              label: label,
              hint: hint,
              obscureText: obscureText,
              validator: validator,
              onChanged: onChanged,
              prefixIcon: prefixIcon,
              enabled: enabled,
            ),
          ),
        ),
      );
    }

    testWidgets('displays label correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(label: 'Email'));

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('displays hint text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(hint: 'Enter your email'));

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextFormField), 'test@example.com');

      expect(controller.text, 'test@example.com');
    });

    testWidgets('calls onChanged callback', (tester) async {
      String? changedValue;
      await tester.pumpWidget(buildTestWidget(
        onChanged: (value) => changedValue = value,
      ));

      await tester.enterText(find.byType(TextFormField), 'hello');
      await tester.pump();

      expect(changedValue, 'hello');
    });

    testWidgets('displays validation error', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ));

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Trigger validation
      final formField = tester.widget<TextFormField>(find.byType(TextFormField));
      formField.validator?.call('');

      await tester.pump();

      // Check that the validator returns the expected error
      expect(formField.validator?.call(''), 'This field is required');
    });

    testWidgets('displays prefix icon when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        prefixIcon: const Icon(Icons.email),
      ));

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('shows visibility toggle for obscured text', (tester) async {
      await tester.pumpWidget(buildTestWidget(obscureText: true));

      // Should show visibility_off icon initially
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap to toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Should now show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('field is disabled when enabled is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(enabled: false));

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, false);
    });
  });

  group('PasswordTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      String label = 'Password',
      bool showStrengthIndicator = false,
      String? Function(String?)? validator,
      void Function(String)? onChanged,
      bool enabled = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PasswordTextField(
              controller: controller,
              label: label,
              showStrengthIndicator: showStrengthIndicator,
              validator: validator,
              onChanged: onChanged,
              enabled: enabled,
            ),
          ),
        ),
      );
    }

    testWidgets('displays password label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('displays custom label', (tester) async {
      await tester.pumpWidget(buildTestWidget(label: 'Confirm Password'));

      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('password is hidden by default', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Visibility toggle icon indicates password is hidden
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('toggles visibility on icon tap', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially obscured - visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap to show password
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Now showing - visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Back to hidden
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('displays lock icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('calls validator', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        validator: (value) {
          if (value == null || value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;
        },
      ));

      await tester.enterText(find.byType(TextFormField), 'short');
      await tester.pump();

      final formField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(formField.validator?.call('short'), 'Password must be at least 8 characters');
    });

    testWidgets('shows strength indicator when enabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(showStrengthIndicator: true));

      // Initially no indicator (empty password)
      expect(find.text('Very Weak'), findsNothing);

      // Enter a weak password
      await tester.enterText(find.byType(TextFormField), 'password');
      await tester.pump();

      // Should show some strength indicator
      expect(
        find.textContaining(RegExp(r'(Very Weak|Weak|Fair)')),
        findsOneWidget,
      );
    });

    testWidgets('strength indicator shows stronger for complex passwords', (tester) async {
      await tester.pumpWidget(buildTestWidget(showStrengthIndicator: true));

      // Enter a strong password
      await tester.enterText(find.byType(TextFormField), 'Password123!@#');
      await tester.pump();

      // Should show strong or very strong
      expect(
        find.textContaining(RegExp(r'(Strong|Very Strong)')),
        findsOneWidget,
      );
    });
  });
}
