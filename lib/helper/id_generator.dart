import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Mengambil counter untuk hari ini
  static Future<int> getCounter(String prefix, String type) async {
    final now = DateTime.now();
    final today = '${_twoDigits(now.year % 100)}${_twoDigits(now.month)}${_twoDigits(now.day)}'; // Correct format YYMMDD
 // DDMMYY (last two digits of year)
    final key = '$prefix-$type-$today';  // Key berdasarkan tanggal

    // Ambil data counter dari Firebase
    DataSnapshot snapshot = await _database.child('counters/$key/counter').get();

    if (snapshot.exists) {
      // Jika data ada, kembalikan nilai counter
      return snapshot.value as int? ?? 0;
    } else {
      // Jika data belum ada, set counter mulai dari 1
      await _database.child('counters/$key/counter').set(1);
      return 1;
    }
  }

  // Menyimpan counter yang sudah diincrement menggunakan transaksi
  static Future<void> incrementCounter(String prefix, String type) async {
    final now = DateTime.now();
    final today = '${_twoDigits(now.year % 100)}${_twoDigits(now.month)}${_twoDigits(now.day)}'; // Correct format YYMMDD
 // DDMMYY (last two digits of year)
    final key = '$prefix-$type-$today';  // Key berdasarkan tanggal

    // Increment counter di Firebase menggunakan transaksi
    await _database.child('counters/$key/counter').runTransaction((mutableData) {
      int currentValue = mutableData as int? ?? 0;  // Ambil nilai counter atau 0 jika null
      mutableData = currentValue + 1;  // Increment counter
      return Transaction.success(mutableData);  // Kembalikan transaksi yang berhasil
    });
  }

  // Helper untuk menambahkan 2 digit di bulan dan hari
  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}

class SimpleIdGenerator {
  static Future<String> generateSimpleId({
    required String prefix,
    required String type,
    int sequenceLength = 4,
  }) async {
    final now = DateTime.now();
    final today = '${_twoDigits(now.year % 100)}${_twoDigits(now.month)}${_twoDigits(now.day)}'; // Correct format YYMMDD
 // Correct format DDMMYY (last two digits of year)
    final key = '$prefix-$type-$today'; // Key using day, month, and last 2 digits of year

    // Get the counter from Firebase
    int counter = await FirebaseHelper.getCounter(prefix, type);

    // Increment the counter in Firebase
    await FirebaseHelper.incrementCounter(prefix, type);

    // Format the sequence to a 4-digit length
    final sequence = counter.toString().padLeft(sequenceLength, '0');

    return '$prefix-$type-$today-$sequence'; // Example: 'INV-BOOK-250828-0001'
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
