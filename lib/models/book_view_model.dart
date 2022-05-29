import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/services/database.dart';

class OkunacakBookViewModel extends ChangeNotifier{
  String _okunacakCollectionPath = 'okunacak_kitaplar';

  Database _database = Database();

  Stream <List<OkunacakBook>>? getOkunacakBookList(){
    const String booksRef = 'okunacak_kitaplar';
    Stream<List<DocumentSnapshot>> streamListDocument = _database
      .getBookListFromApi(booksRef)
      .map((querySnapshot) => querySnapshot.docs);
      Stream<List<OkunacakBook>> streamListBook = 
        streamListDocument.map((listOfDocSnap) => listOfDocSnap.map((docSnap) => OkunacakBook.fromMap(docSnap.data() as Map<String, dynamic>)).toList());
      return streamListBook;
  }
  Future<void> deleteBook(OkunacakBook book)async{
    await _database.deleteDocument(referencePath: _okunacakCollectionPath, id: book.id);
  }
}



class OkunmusBookViewModel extends ChangeNotifier{
  String _okunmusCollectionPath = 'okunmus_kitaplar';

  Database _database = Database();

  Stream <List<OkunmusBook>>? getOkunmusBookList(){
    const String booksRef = 'okunmus_kitaplar';
    Stream<List<DocumentSnapshot>> streamListDocument = _database
    .getBookListFromApi(booksRef)
    .map((querySnapshot) => querySnapshot.docs);
    Stream<List<OkunmusBook>> streamListBook = 
      streamListDocument.map((listOfDocSnap) => listOfDocSnap.map((docSnap) => OkunmusBook.fromMap(docSnap.data() as Map<String, dynamic>)).toList());
    return streamListBook;
  } 
  Future<void> deleteBook(OkunmusBook book)async{
    await _database.deleteDocument(referencePath: _okunmusCollectionPath, id: book.id);
  }
}