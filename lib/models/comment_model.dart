import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String text;
  final String userEmail;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.text,
    required this.userEmail,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      text: data['text'] ?? '',
      userEmail: data['userEmail'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userEmail': userEmail,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
