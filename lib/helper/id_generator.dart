class SimpleIdGenerator {
  static final Map<String, int> _counters = {};
  static final Map<String, String> _lastDate = {};

  /// Simple version tanpa persistence
  static String generateSimpleId({
    required String prefix,
    required String type,
    int sequenceLength = 4,
  }) {
    final now = DateTime.now();
    final today = '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}';
    final key = '$prefix$type$today';

    // Reset counter jika hari berubah
    if (_lastDate[key] != today) {
      _counters[key] = 0;
      _lastDate[key] = today;
    }

    // Increment counter
    _counters[key] = (_counters[key] ?? 0) + 1;
    final counter = _counters[key]!;

    // Format sequence
    final sequence = counter.toString().padLeft(sequenceLength, '0');

    return '$prefix-$type-$today-$sequence';
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}

// Contoh penggunaan simple:
// String invoiceId = SimpleIdGenerator.generateSimpleId(prefix: 'GPH', type: 'INV');
// Hasil: GPH-INV-20250826-0001