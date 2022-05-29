import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/senin_notlar%C4%B1n_model.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot>getBookListFromApi(String referencePath){
    return _firestore.collection(referencePath).snapshots();
  }

  Stream<QuerySnapshot>getNotListFromApi(String referencePath){
    return _firestore.collection(referencePath).snapshots();
  }

  Future<void> deleteDocument({String? referencePath, String? id})async{
    await _firestore.collection(referencePath!).doc(id).delete();
  }

  Future<void> setOkunacakBookData(
    {required String collectionPath, Map<String, dynamic>? bookAsMap}
  )async{
    await _firestore
      .collection(collectionPath)
      .doc(OkunacakBook.fromMap(bookAsMap!).id)
      .set(bookAsMap);
  }

  Future<void> setOkunmusBookData(
    {required String collectionPath, Map<String, dynamic>? bookAsMap}
  ) async {
    await _firestore
    .collection(collectionPath)
    .doc(OkunmusBook.fromMap(bookAsMap!).id)
    .set(bookAsMap);
  }

  Future<void> setSeninNotlarin(
    {required String collectionPath, Map<String, dynamic>? notAsMap}
  )async {
    await _firestore
    .collection(collectionPath)
    .doc(SeninNotlarin.fromMap(notAsMap!).id)
    .set(notAsMap);
  }

  // Stream <QuerySnapshot> getNotListFromApi(String notReferencePath){
  //   return _firestore.collection(notReferencePath).doc('İnsanın Merak Yolculuğu').collection('notlar').snapshots();
  // }
}