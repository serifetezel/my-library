import 'package:flutter/cupertino.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:my_library/services/database.dart';

class AddOkunacakBookViewModel extends ChangeNotifier {
  Database _database = Database();
  String okunacakCollectionPath = 'okunacak_kitaplar';

  Future <void> addOkunacakNewBook (
    {
      required String bookName, required String authorName, photoUrl ,required DateTime plannedDate, required bool nowReading, required int pageNumber
    }
  ) async {
    OkunacakBook newOkunacakBook = OkunacakBook(
      id: DateTime.now().toString(),
      bookName: bookName,
      authorName: authorName,
      photoUrl: photoUrl,
      pageNumber: pageNumber,
      nowReading: nowReading,
      plannedDate: Calculator.datetimeToTimestamp(plannedDate),
      notes: []
    );

    await _database.setOkunacakBookData(collectionPath: okunacakCollectionPath,
      bookAsMap: newOkunacakBook.toMap()
    );
  }
}


class AddOkunmusBookViewModel extends ChangeNotifier{
  Database _database = Database();
  String okunmusCollectionPath = 'okunmus_kitaplar';

  Future <void> addOkunmusNewBook (
    {
      required String bookName, required String authorName, photoUrl, required DateTime readDate, required bool nowReading, required int pageNumber
    }
  )async{
    OkunmusBook newOkunmusBook = OkunmusBook(
      id: DateTime.now().toString(), 
      bookName: bookName, 
      authorName: authorName, 
      photoUrl: photoUrl,
      readDate: Calculator.datetimeToTimestamp(readDate), 
      nowReading: nowReading, 
      pageNumber: pageNumber, 
      notes: []
    );

    await _database.setOkunmusBookData(collectionPath: okunmusCollectionPath,
      bookAsMap: newOkunmusBook.toMap()
    );
  }
}