import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/utils/widgets/email_validator.dart';

void main() {
  group('Email Validation Test', () {
    test('Empty Email Test', () {
      String emptyEmail = '';
      expect(Validator.validateEmail(emptyEmail), false);
    });

    test('Valid Email Test', () {
      String validEmail = 'test@example.com';
      expect(Validator.validateEmail(validEmail), true);
    });

    test('Invalid Email Test', () {
      String invalidEmail = 'invalidemail@';
      expect(Validator.validateEmail(invalidEmail), false);
    });
  });
}

