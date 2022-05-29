import 'package:cloud_firestore/cloud_firestore.dart';

class SeninNotlarin{
  final String id;
  final String not;
  final Timestamp tarih;

  SeninNotlarin({
    required this.id,
    required this.not,
    required this.tarih
  });

  Map<String, dynamic> toMap()  {
    return{
    'id' : id,
    'not' : not,
    'tarih' : tarih
    };
  }

  factory SeninNotlarin.fromMap(Map map) {
  return SeninNotlarin(
    id: map['id'],
    not: map['not'],
    tarih: map['tarih']
  );
  }
}