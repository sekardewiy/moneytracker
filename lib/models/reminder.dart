import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String name;
  final DateTime dueDate;
  bool isPaid;

  Reminder({
    required this.name,
    required this.dueDate,
    this.isPaid = false,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      name: json['name'],
      dueDate: DateTime.parse(json['dueDate']),
      isPaid: json['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid,
    };
  }

  // Simpan data Reminder ke Firestore
  Future<void> saveToFirestore(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('reminders')
          .doc(name) // Gunakan name sebagai ID dokumen
          .set(toJson());
    } catch (e) {
      print('Error saving reminder: $e');
    }
  }

  // Ambil data Reminder dari Firestore
  static Future<Reminder?> fromFirestore(String userId, String name) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('reminders')
          .doc(name)
          .get();

      if (docSnapshot.exists) {
        return Reminder.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching reminder: $e');
      return null;
    }
  }
}
