/// A comprehensive phone number validator with support for international formats
class PhoneValidator {
  /// Validates a phone number with configurable strictness
  ///
  /// Parameters:
  /// - [value]: The phone number string to validate
  /// - [strict]: If true, enforces stricter validation rules
  /// - [allowSpaces]: Whether to allow spaces in the phone number
  ///
  /// Returns true if the phone number is valid according to the specified rules
  static bool isValid(String value, {bool strict = false, bool allowSpaces = true}) {
    if (value.isEmpty) return false;

    // Normalize the input by trimming whitespace
    String normalizedValue = value.trim();

    // Remove allowed separators for consistent validation
    if (allowSpaces) {
      normalizedValue = normalizedValue.replaceAll(RegExp(r'[\s\-\.$$$$]'), '');
    } else {
      normalizedValue = normalizedValue.replaceAll(RegExp(r'[\-\.$$$$]'), '');
    }

    // Basic validation - must contain only digits, +, and optionally #,* for extensions
    if (!RegExp(r'^[0-9\+\#\*]+$').hasMatch(normalizedValue)) {
      return false;
    }

    // Check minimum length (excluding the + for international numbers)
    int effectiveLength = normalizedValue.startsWith('+')
        ? normalizedValue.length - 1
        : normalizedValue.length;

    if (effectiveLength < 6) {
      return false;
    }

    if (strict) {
      // Strict mode validation

      // International format validation (E.164 compliant)
      if (normalizedValue.startsWith('+')) {
        // International numbers should have 7-15 digits after the country code
        // Country codes are 1-3 digits, so total length should be 8-18 digits including +
        return normalizedValue.length >= 8 &&
            normalizedValue.length <= 18 &&
            RegExp(r'^\+[1-9][0-9]{0,2}[0-9]{6,14}$').hasMatch(normalizedValue);
      }

      // National format validation (without + prefix)
      else {
        // National numbers should have at least 7 digits
        return normalizedValue.length >= 7 &&
            normalizedValue.length <= 15 &&
            RegExp(r'^[0-9]{7,15}$').hasMatch(normalizedValue);
      }
    } else {
      // Lenient mode - just check reasonable length and digit composition
      return (normalizedValue.startsWith('+') && normalizedValue.length >= 8) ||
          (!normalizedValue.startsWith('+') && normalizedValue.length >= 6);
    }
  }

  /// Validates a phone number with country code consideration
  ///
  /// Parameters:
  /// - [value]: The phone number string to validate
  /// - [countryCode]: Optional ISO country code (e.g., 'US', 'FR') for country-specific validation
  ///
  /// Returns true if the phone number is valid for the specified country
  static bool isValidForCountry(String value, String countryCode) {
    // Normalize input
    String normalizedValue = value.trim();
    countryCode = countryCode.toUpperCase();

    // Remove formatting characters
    normalizedValue = normalizedValue.replaceAll(RegExp(r'[\s\-\.$$$$]'), '');

    // Country-specific validation rules
    switch (countryCode) {
      case 'US':
      case 'CA':
      // North American Numbering Plan: +1 NXX-NXX-XXXX (10 digits)
        return RegExp(r'^(\+?1)?[2-9][0-9]{2}[2-9][0-9]{2}[0-9]{4}$').hasMatch(normalizedValue);

      case 'GB':
      // UK: +44 XXXX XXXXXX (various formats)
        return normalizedValue.startsWith('+44') || normalizedValue.startsWith('44') ||
            (normalizedValue.startsWith('0') && normalizedValue.length >= 10);

      case 'IN':
      // India: +91 XXXXXXXXXX (10 digits)
        return RegExp(r'^(\+?91)?[6-9][0-9]{9}$').hasMatch(normalizedValue);

      case 'FR':
      // France: +33 X XX XX XX XX (9 digits)
        return RegExp(r'^(\+?33)?[1-9][0-9]{8}$').hasMatch(normalizedValue);

      case 'NG':
      // Nigeria: +234 XXX XXX XXXX (10 digits)
        return RegExp(r'^(\+?234)?[0]?[7-9][0-1][0-9]{8}$').hasMatch(normalizedValue);

      case 'GH':
      // Ghana: +233 XX XXX XXXX (9 digits)
        return RegExp(r'^(\+?233)?[0]?[2-5][0-9]{8}$').hasMatch(normalizedValue);

      case 'CI':
      // Côte d'Ivoire: +225 XX XX XX XX XX (10 digits)
        return RegExp(r'^(\+?225)?[0]?[0-9]{10}$').hasMatch(normalizedValue);

      case 'SN':
      // Senegal: +221 XX XXX XX XX (9 digits)
        return RegExp(r'^(\+?221)?[7][0-9]{8}$').hasMatch(normalizedValue);

      case 'BJ':
      // Benin: +229 01 XX XXX XXX (10 digits)
        return RegExp(r'^(\+?22901)?[0]?[2-9][0-9]{7}$').hasMatch(normalizedValue);

      default:
      // Default to basic validation for other countries
        return isValid(normalizedValue, strict: true);
    }
  }

  /// Formats a phone number for display
  ///
  /// Parameters:
  /// - [value]: The phone number string to format
  /// - [format]: The desired format ('international', 'national', or 'e164')
  ///
  /// Returns the formatted phone number string
  static String format(String value, {String format = 'international'}) {
    // Remove all non-digit characters except +
    String digitsOnly = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Handle empty input
    if (digitsOnly.isEmpty) return value;

    // Format based on the specified format type
    switch (format) {
      case 'e164':
      // E.164 format: +[country code][number]
        if (!digitsOnly.startsWith('+')) {
          return '+$digitsOnly';
        }
        return digitsOnly;

      case 'national':
      // National format without country code
        if (digitsOnly.startsWith('+')) {
          // Try to remove country code (assuming 1-3 digits)
          for (int i = 1; i <= 3; i++) {
            if (digitsOnly.length > i) {
              digitsOnly = digitsOnly.substring(i + 1);
              break;
            }
          }
        }

        // Format as XXX-XXX-XXXX if 10 digits
        if (digitsOnly.length == 10) {
          return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
        }
        return digitsOnly;

      case 'international':
      default:
      // International format with spaces
        if (digitsOnly.startsWith('+')) {
          // Try to identify country code (1-3 digits)
          for (int i = 1; i <= 3; i++) {
            if (digitsOnly.length > i + 6) { // Ensure there's enough digits after country code
              return '${digitsOnly.substring(0, i + 1)} ${digitsOnly.substring(i + 1)}';
            }
          }
        }

        // If we can't determine format, return with + prefix
        return digitsOnly.startsWith('+') ? digitsOnly : '+$digitsOnly';
    }
  }
}