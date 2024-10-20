// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService(); // Firestore

  final TextEditingController textController =
      TextEditingController(); //Text controller

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreService
                            .addNotes(textController.text); //ADD NEW NOTE
                      } else {
                        firestoreService.updateNotes(
                            docID, textController.text); //UPDATE EXCISTING NOTE
                      }

                      textController.clear();

                      Navigator.pop(context);
                    },
                    child: Text('Add'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: openNoteBox,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //if has data get all data
              List notesList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document =
                      notesList[index]; //get each individual docs
                  String docID = document.id;

                  Map<String, dynamic> data = //get note from each doc
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  return ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => openNoteBox(docID: docID),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                firestoreService.deleteNotes(docID),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ));
                },
              );
            } else {
              //if there are no data
              return const Text('No notes..');
            }
          }),
    );
  }
}
