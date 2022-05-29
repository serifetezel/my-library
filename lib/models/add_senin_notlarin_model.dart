import 'package:flutter/foundation.dart';
import 'package:my_library/models/senin_notlar%C4%B1n_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:my_library/services/database.dart';

class AddSeninNotlarinModel extends ChangeNotifier{
  Database _database = Database();
  String seninNotlarinCollectionPath = 'senin_notların';

  Future <void> addSeninNotlarinNewNot(
    {
      required String not, required DateTime tarih
    }
  )async{
    SeninNotlarin newNot = SeninNotlarin(
      id: DateTime.now().toString(), 
      not: not, 
      tarih: Calculator.datetimeToTimestamp(tarih)
    );

    await _database.setSeninNotlarin(collectionPath: seninNotlarinCollectionPath,
      notAsMap: newNot.toMap()
    );
  }
}