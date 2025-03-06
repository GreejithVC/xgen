extension EmailExtensions on String {
  String maskEmail() {
    final parts = split('@');
    final localPart = parts[0];
    int showChar = 3;
    if (localPart.length <= 3) {
      showChar = 1;
    }
    final maskedLocalPart =
        '${localPart.substring(0, showChar)}${'*' * (localPart.length - showChar)}';
    return '$maskedLocalPart@${parts[1]}';
  }
}
