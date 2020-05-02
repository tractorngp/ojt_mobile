class Validations{
  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Token ID is required.';
    // final RegExp emailExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    // if (!emailExp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  String isEmpty(String value) {
    if (value.isEmpty) return 'Required field.';
    
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Please enter your password.';
    // final RegExp emailExp = new RegExp(r'/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}/');
    // if (!emailExp.hasMatch(value)) return 'Password must contain : \nA lowercase letter, \nA captial(uppercase) letter, \nA number and Mininum 8 characters.';
    
    return null;
  }
}