class AisleyFormatters {
  AisleyFormatters._();

  /// Formats amount to Philippine Peso currency e.g. ₱14,850.00
  static String formatPhp(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final parts = absAmount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }

    final formatted = '₱$buffer.$decimalPart';
    return isNegative ? '-$formatted' : formatted;
  }

  /// Calculates age from birthdate string in format 'YYYY-MM-DD'
  static int calculateAge(String birthdayStr) {
    if (birthdayStr.isEmpty) return 0;
    try {
      final parts = birthdayStr.split('-');
      if (parts.length != 3) return 0;
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();

      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age >= 0 ? age : 0;
    } catch (_) {
      return 0;
    }
  }

  /// Formats date to 'YYYY-MM-DD'
  static String toIsoDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Formats date to readable 'Aug 21, 2026'
  static String toReadableDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthStr = months[date.month - 1];
    return '$monthStr ${date.day}, ${date.year}';
  }
}
