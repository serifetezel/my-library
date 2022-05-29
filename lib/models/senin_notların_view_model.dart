import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_library/models/senin_notlar%C4%B1n_model.dart';
import 'package:my_library/services/database.dart';

class SeninNotlarinViewModel extends ChangeNotifier {
  
  String _seninNotlarinCollectionPath = 'senin_notların';

  Database _database = Database();

  Stream <List<SeninNotlarin>>? getSeninNotlarinList(){
    const String notRef = 'senin_notların';

    Stream<List<DocumentSnapshot>> streamListDocument = _database
    .getNotListFromApi(notRef)
    .map((querySnapshot) => querySnapshot.docs);
    Stream<List<SeninNotlarin>> streamListNot =
      streamListDocument.map((listOfDocSnap) => listOfDocSnap.map((docSnap) => SeninNotlarin.fromMap(docSnap.data() as Map<String, dynamic>)).toList());
    return streamListNot;
  }
  Future<void> deleteNot(SeninNotlarin not)async{
    await _database.deleteDocument(referencePath: _seninNotlarinCollectionPath, id: not.id);
  }
}