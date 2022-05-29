import 'package:flutter/cupertino.dart';
import 'package:my_library/models/senin_notlar%C4%B1n_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:my_library/services/database.dart';

class UpdateSeninNotlarinViewModel extends ChangeNotifier{
  Database _database = Database();
  String seninNotlarinCollectionPath = 'senin_notların';

  Future <void> updateSeninNotlarin (
    {
      required String not, required DateTime tarih, required SeninNotlarin note
    }
  ) async {
    SeninNotlarin newSeninNotun = SeninNotlarin(
      id: note.id, 
      not: not, 
      tarih: Calculator.datetimeToTimestamp(tarih),
    );

    await _database.setSeninNotlarin(collectionPath: seninNotlarinCollectionPath,
      notAsMap: newSeninNotun.toMap()
    );
  }
}