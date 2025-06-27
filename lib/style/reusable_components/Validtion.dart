class Validation {
  static String? fullNameValidator(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    String? result = fullNameValidator(value, "Should enter your email");
    if (result == null) {
      if (!isValidEmail(value!)) {
        result = "email is not valid";
      }
    }
    return result;
  }

  static bool isValidEmail(String email) {
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    return emailValid;
  }

  static String? ageValidator(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    int? age = int.tryParse(value);
    if (age == null || age < 0 || age > 100) {
      return "Invalid age";
    }
    return null;
  }
}