
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xgen/models/Notes.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  /// Fetch notes for the currently logged-in user
  Future<List<Note>> fetchNotes() async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(_userId)
        .collection("notes")
        .orderBy("time", descending: true)
        .limit(10)
        .get();

    return Note.fromListJson(querySnapshot.docs); // Pass the correct type
  }


  /// Create a new note
  Future<void> addNote(String title, String content) async {
    await _firestore.collection("users").doc(_userId).collection("notes").add({
      'title': title,
      'content': content,
      'time': FieldValue.serverTimestamp(),
    });
  }

  /// Update an existing note
  Future<void> updateNote(String noteId, String title, String content) async {
    await _firestore.collection("users").doc(_userId).collection("notes").doc(noteId).update({
      'title': title,
      'content': content,
      'time': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection("users").doc(_userId).collection("notes").doc(noteId).delete();
  }
}

