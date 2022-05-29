import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/notes_model.dart';

class OkunacakBook{
  final String id;
  final String bookName;
  final String authorName;
  final String photoUrl;
  final Timestamp plannedDate;
  late final bool nowReading;
  final int pageNumber;
  final List<Notes> notes;


  OkunacakBook({
    required this.id, 
    required this.bookName, 
    required this.photoUrl, 
    required this.authorName, 
    required this.plannedDate, 
    required this.nowReading, 
    required this.pageNumber, 
    required this.notes
  });

  Map<String, dynamic> toMap()  {

    List<Map<String,dynamic>> notes = this.notes.map((notes) => notes.toMap()).toList();

    return{
    'id' : id,
    'bookName' : bookName,
    'authorName' : authorName,
    'photoUrl' : photoUrl,
    'plannedDate' : plannedDate,
    'nowReading' : nowReading,
    'pageNumber' : pageNumber,
    'notes' : notes
    };
  }

  factory OkunacakBook.fromMap(Map map) {

  var notesListAsMap = map['notes'] as List;
    List<Notes> notes = notesListAsMap.map((notesAsMap) => Notes.fromMap(notesAsMap)).toList();

    return OkunacakBook(
      id: map['id'],
      bookName: map['bookName'],
      authorName: map['authorName'],
      photoUrl: map['photoUrl'],
      plannedDate: map['plannedDate'],
      nowReading: map['nowReading'],
      pageNumber: map['pageNumber'],
      notes: notes
    );
  }
}


class OkunmusBook{
  final String id;
  final String bookName;
  final String authorName;
  final String photoUrl;
  final Timestamp readDate;
  late final bool nowReading;
  final int pageNumber;
  final List<Notes> notes;

  OkunmusBook({required this.id, required this.bookName, required this.authorName, required this.photoUrl, required this.readDate, required this.nowReading, required this.pageNumber, required this.notes});

  Map<String, dynamic> toMap()  {

    List<Map<String,dynamic>> notes = this.notes.map((notes) => notes.toMap()).toList();

    return{
    'id' : id,
    'bookName' : bookName,
    'authorName' : authorName,
    'photoUrl' : photoUrl,
    'readDate' : readDate,
    'nowReading' : nowReading,
    'pageNumber' : pageNumber,
    'notes' : notes
    };
  }

  factory OkunmusBook.fromMap(Map map) {

  var notesListAsMap = map['notes'] as List;
    List<Notes> notes = notesListAsMap.map((notesAsMap) => Notes.fromMap(notesAsMap)).toList();
     return OkunmusBook(
      id: map['id'],
      bookName: map['bookName'],
      authorName: map['authorName'],
      photoUrl: map['photoUrl'],
      readDate: map['readDate'],
      nowReading: map['nowReading'],
      pageNumber: map['pageNumber'],
      notes: notes
    );
  }
}