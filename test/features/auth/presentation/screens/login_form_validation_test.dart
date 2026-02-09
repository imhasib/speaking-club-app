import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/core/utils/validators.dart';

void main() {
  group('Login Form Validation', () {
    late GlobalKey<FormState> formKey;

    Widget buildTestForm({
      String? Function(String?)? emailValidator,
      String? Function(String?)? passwordValidator,
    }) {
      formKey = GlobalKey<FormState>();
      return MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const Key('email_field'),
                  validator: emailValidator ?? Validators.validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  key: const Key('password_field'),
                  validator: passwordValidator ??
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                ElevatedButton(
                  key: const Key('submit_button'),
                  onPressed: () {
                    formKey.currentState?.validate();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('shows error for empty email', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('email_field')), '');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows error for invalid email format', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('accepts valid email', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Please enter a valid email address'), findsNothing);
    });

    testWidgets('shows error for empty password', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), '');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('accepts non-empty password', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Password is required'), findsNothing);
    });

    testWidgets('validates both fields on submit', (tester) async {
      await tester.pumpWidget(buildTestForm());

      // Leave both fields empty and submit
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('form is valid with correct inputs', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      final isValid = formKey.currentState?.validate() ?? false;
      expect(isValid, true);
    });
  });

  group('Registration Form Validation', () {
    late GlobalKey<FormState> formKey;

    Widget buildTestForm() {
      formKey = GlobalKey<FormState>();
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('username_field'),
                    validator: Validators.validateUsername,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextFormField(
                    key: const Key('email_field'),
                    validator: Validators.validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    key: const Key('mobile_field'),
                    validator: Validators.validateMobileNumber,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Mobile'),
                  ),
                  TextFormField(
                    key: const Key('password_field'),
                    validator: Validators.validatePassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    key: const Key('submit_button'),
                    onPressed: () {
                      formKey.currentState?.validate();
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('shows error for short username', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('username_field')), 'ab');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Username must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('shows error for username with special characters', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('username_field')), 'user@name');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Username can only contain letters, numbers, underscores, and hyphens'), findsOneWidget);
    });

    testWidgets('accepts valid username', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('username_field')), 'valid_user123');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Username must be at least 3 characters'), findsNothing);
      expect(find.text('Username can only contain letters, numbers, underscores, and hyphens'), findsNothing);
    });

    testWidgets('shows error for invalid mobile number', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('mobile_field')), '1234567890');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Please enter a valid mobile number with country code'), findsOneWidget);
    });

    testWidgets('accepts valid mobile number', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('mobile_field')), '+1234567890');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Please enter a valid mobile number with country code'), findsNothing);
    });

    testWidgets('shows error for weak password', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'weak');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.textContaining('at least'), findsOneWidget);
    });

    testWidgets('shows error for password without uppercase', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'password123!');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.textContaining('uppercase'), findsOneWidget);
    });

    testWidgets('shows error for password without special character', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'Password123');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.textContaining('special character'), findsOneWidget);
    });

    testWidgets('accepts strong password', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'StrongPass1!');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.textContaining('at least'), findsNothing);
      expect(find.textContaining('uppercase'), findsNothing);
      expect(find.textContaining('special character'), findsNothing);
    });
  });

  group('Confirm Password Validation', () {
    late GlobalKey<FormState> formKey;
    late TextEditingController passwordController;

    Widget buildTestForm() {
      formKey = GlobalKey<FormState>();
      passwordController = TextEditingController();
      return MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const Key('password_field'),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                TextFormField(
                  key: const Key('confirm_password_field'),
                  validator: (value) =>
                      Validators.validateConfirmPassword(value, passwordController.text),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                ),
                ElevatedButton(
                  key: const Key('submit_button'),
                  onPressed: () {
                    formKey.currentState?.validate();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('shows error when passwords do not match', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), 'different123');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('accepts matching passwords', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), 'password123');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsNothing);
    });

    testWidgets('shows error for empty confirm password', (tester) async {
      await tester.pumpWidget(buildTestForm());

      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), '');
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Please confirm your password'), findsOneWidget);
    });
  });
}
