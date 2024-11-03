extension MusilyString on String {
  bool get isUrl {
    return RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$').hasMatch(this);
  }

  bool get isDirectory {
    const directoryPattern = r'^(/[^/ ]*)+/?$';
    final directoryRegex = RegExp(directoryPattern);
    return directoryRegex.hasMatch(this);
  }
}
