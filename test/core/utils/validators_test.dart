import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('email validation', () {
      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(Validators.validateEmail('user+tag@example.org'), isNull);
      });

      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('returns error for invalid email format', () {
        expect(Validators.validateEmail('invalid'), isNotNull);
        expect(Validators.validateEmail('invalid@'), isNotNull);
        expect(Validators.validateEmail('@domain.com'), isNotNull);
        expect(Validators.validateEmail('user@'), isNotNull);
      });
    });

    group('password validation', () {
      test('returns null for valid password', () {
        expect(Validators.validatePassword('Password1!'), isNull);
        expect(Validators.validatePassword('MySecure1Pass@'), isNull);
      });

      test('returns error for short password', () {
        expect(Validators.validatePassword('Ab1!'), isNotNull);
        expect(Validators.validatePassword('Pass1!'), isNotNull);
      });

      test('returns error for password without uppercase', () {
        expect(Validators.validatePassword('password123!'), isNotNull);
      });

      test('returns error for password without lowercase', () {
        expect(Validators.validatePassword('PASSWORD123!'), isNotNull);
      });

      test('returns error for password without digit', () {
        expect(Validators.validatePassword('PasswordOnly!'), isNotNull);
      });

      test('returns error for password without special character', () {
        expect(Validators.validatePassword('Password123'), isNotNull);
      });

      test('returns error for empty password', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword(null), isNotNull);
      });
    });

    group('username validation', () {
      test('returns null for valid username', () {
        expect(Validators.validateUsername('user123'), isNull);
        expect(Validators.validateUsername('test_user'), isNull);
        expect(Validators.validateUsername('TestUser'), isNull);
        expect(Validators.validateUsername('test-user'), isNull);
      });

      test('returns error for short username', () {
        expect(Validators.validateUsername('ab'), isNotNull);
      });

      test('returns error for username with special characters', () {
        expect(Validators.validateUsername('user@name'), isNotNull);
        expect(Validators.validateUsername('user name'), isNotNull);
      });

      test('returns error for empty username', () {
        expect(Validators.validateUsername(''), isNotNull);
        expect(Validators.validateUsername(null), isNotNull);
      });
    });

    group('mobile number validation', () {
      test('returns null for valid mobile number', () {
        expect(Validators.validateMobileNumber('+1234567890'), isNull);
        expect(Validators.validateMobileNumber('+8801712345678'), isNull);
      });

      test('returns error for invalid phone format', () {
        expect(Validators.validateMobileNumber('1234567890'), isNotNull);
        expect(Validators.validateMobileNumber('abc123'), isNotNull);
      });

      test('returns error for empty phone', () {
        expect(Validators.validateMobileNumber(''), isNotNull);
        expect(Validators.validateMobileNumber(null), isNotNull);
      });
    });

    group('confirm password validation', () {
      test('returns null when passwords match', () {
        expect(Validators.validateConfirmPassword('password', 'password'), isNull);
      });

      test('returns error when passwords do not match', () {
        expect(Validators.validateConfirmPassword('password1', 'password2'), isNotNull);
      });

      test('returns error for empty confirm password', () {
        expect(Validators.validateConfirmPassword('', 'password'), isNotNull);
        expect(Validators.validateConfirmPassword(null, 'password'), isNotNull);
      });
    });
  });

  group('Password Strength', () {
    test('returns 0 for very short passwords', () {
      expect(Validators.getPasswordStrength('a'), 0);
      expect(Validators.getPasswordStrength('abc'), 0);
    });

    test('returns low strength for simple passwords', () {
      expect(Validators.getPasswordStrength('password'), lessThanOrEqualTo(2));
    });

    test('returns higher strength for complex passwords', () {
      expect(Validators.getPasswordStrength('Password123'), greaterThanOrEqualTo(2));
    });

    test('returns max strength for very complex passwords', () {
      expect(Validators.getPasswordStrength('Password123!@#abc'), 4);
    });

    test('getPasswordStrengthLabel returns correct labels', () {
      expect(Validators.getPasswordStrengthLabel(0), 'Very Weak');
      expect(Validators.getPasswordStrengthLabel(1), 'Weak');
      expect(Validators.getPasswordStrengthLabel(2), 'Fair');
      expect(Validators.getPasswordStrengthLabel(3), 'Strong');
      expect(Validators.getPasswordStrengthLabel(4), 'Very Strong');
    });
  });
}
