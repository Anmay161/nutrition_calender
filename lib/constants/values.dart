class Values {
  static final List<String> gender = ['Male','Female'];
  static final List<String> list1 = ['value1', 'vlaue2', 'value3'];
  static final List<String> list2 = ['','value1', 'vlaue2', 'value3'];
  static final List<String> list3 = ['','value1', 'vlaue2', 'value3'];
}

class Regex {
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
  );

  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }
  static bool isValidPassword(String password) {
    return passwordRegex.hasMatch(password);
  }
}
