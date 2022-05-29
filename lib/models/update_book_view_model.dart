import 'package:flutter/foundation.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:my_library/services/database.dart';

class UpdateOkunacakBookViewModel extends ChangeNotifier{
  Database _database = Database();
  String okunacakCollectionPath = 'okunacak_kitaplar';

  Future <void> updateOkunacakBook (
    {
      required String bookName, required String authorName, photoUrl,required DateTime plannedDate, required bool nowReading, required int pageNumber, required OkunacakBook book
    }
  ) async {
   
    OkunacakBook newOkunacakBook = OkunacakBook(
      id: book.id,
      bookName: bookName,
      authorName: authorName,
      photoUrl: photoUrl,
      pageNumber: pageNumber,
      nowReading: nowReading,
      plannedDate: Calculator.datetimeToTimestamp(plannedDate),
      notes: book.notes
    );

    await _database.setOkunacakBookData(collectionPath: okunacakCollectionPath,
      bookAsMap: newOkunacakBook.toMap()
    );
  }
}


class UpdateOkunmusBookViewModel extends ChangeNotifier{
  Database _database = Database();
  String okunmusCollectionPath = 'okunmus_kitaplar';

  Future <void> updateOkunmusBook (
    {
      required String bookName, required String authorName, photoUrl, required DateTime readDate, required bool nowReading, required int pageNumber, required OkunmusBook book
    }
  ) async {
    OkunmusBook newOkunmusBook = OkunmusBook(
      id: book.id, 
      bookName: bookName, 
      authorName: authorName, 
      photoUrl: photoUrl,
      readDate: Calculator.datetimeToTimestamp(readDate), 
      nowReading: nowReading, 
      pageNumber: pageNumber, 
      notes: book.notes
    );

    await _database.setOkunmusBookData(collectionPath: okunmusCollectionPath,
      bookAsMap: newOkunmusBook.toMap()
    );
  }
}