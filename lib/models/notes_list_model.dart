import 'package:flutter/foundation.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/notes_model.dart';
import 'package:my_library/services/database.dart';

class OkunacakNotesListModel extends ChangeNotifier{
  Database _database = Database();
  String okunacakCollectionPath = 'okunacak_kitaplar';

  Future<void> updateNote({required List<Notes> noteList, OkunacakBook? book}) async{
    OkunacakBook newOkunacakBook = OkunacakBook(
      id: book!.id,
      bookName: book.bookName,
      authorName: book.authorName,
      pageNumber: book.pageNumber,
      photoUrl: book.photoUrl,
      plannedDate: book.plannedDate,
      nowReading: book.nowReading,
      notes: noteList
    );

    await _database.setOkunacakBookData(
      collectionPath: okunacakCollectionPath, bookAsMap: newOkunacakBook.toMap()
    );
  }
}

class OkunmusNotesListModel extends ChangeNotifier{
  Database _database = Database();
  String okunmusCollectionPath = 'okunmus_kitaplar';

  Future<void> updateNote({required List<Notes> noteList, OkunmusBook? book})async{
    OkunmusBook newOkunmusBook = OkunmusBook(
      id: book!.id,
      bookName: book.bookName,
      authorName: book.authorName,
      photoUrl: book.photoUrl,
      pageNumber: book.pageNumber,
      readDate: book.readDate,
      nowReading: book.nowReading,
      notes: noteList
    );
    await _database.setOkunmusBookData(
      collectionPath: okunmusCollectionPath, bookAsMap: newOkunmusBook.toMap());
  }
}