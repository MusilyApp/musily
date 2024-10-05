bool validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
  return emailRegExp.hasMatch(value);
}
