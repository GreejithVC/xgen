import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note({
    this.id,
    this.title,
    this.content,
    this.timestamp,
  });

  final String? id;
  final String? title;
  final String? content;
  final DateTime? timestamp;

  /// Convert Firestore document list to a list of Note objects
  static List<Note> fromListJson(List<DocumentSnapshot> json) {
    return json
        .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
        .toList();
  }


  /// Convert Firestore document to Note object
  static Note fromJson(Map<String, dynamic> json, {String? id}) {
    return Note(
      id: id,
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      timestamp: json['time'] != null ? (json['time'] as Timestamp).toDate() : null,
    );
  }

  /// Convert Note object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'time': timestamp ?? FieldValue.serverTimestamp(),
    };
  }
}
