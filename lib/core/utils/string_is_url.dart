bool stringIsUrl(String string) {
  return RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$').hasMatch(string);
}
