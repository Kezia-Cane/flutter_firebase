import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //GET COLLECTION NOTES DB
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //CREATE
  Future<void> addNotes(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //READ
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //UPDATE
  Future<void> updateNotes(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //DELETE
  Future<void> deleteNotes(String docID) {
    return notes.doc(docID).delete();
  }
}
