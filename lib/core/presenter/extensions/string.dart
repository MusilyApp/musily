extension MusilyString on String {
  bool get isUrl {
    return RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$').hasMatch(this);
  }

  bool get isDirectory {
    final directoryRegex =
        RegExp(r'^(?:[a-zA-Z]:\\|/)(?:[^<>:"|?*\n]+[\\/])*[^<>:"|?*\n]*$');
    return directoryRegex.hasMatch(this);
  }
}
