bool isValidEmail(String value) {
  String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(value);
}
