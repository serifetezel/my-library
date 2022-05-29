import 'package:flutter/material.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/notes_list_model.dart';
import 'package:my_library/models/notes_model.dart';
import 'package:my_library/screens/book_view.dart';
import 'package:provider/provider.dart';

class NoteOkunacakList extends StatefulWidget {
  
  final OkunacakBook book;
  const NoteOkunacakList({Key? key, required this.book}) : super(key: key);
  @override
  _NoteOkunacakListState createState() => _NoteOkunacakListState();
}

class _NoteOkunacakListState extends State<NoteOkunacakList> {
  @override
  Widget build(BuildContext context) {

    List<Notes> notes = widget.book.notes;
    return  ChangeNotifierProvider<OkunacakNotesListModel>(
      create: (context)=>OkunacakNotesListModel(),
      
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          toolbarHeight: 80,
          centerTitle: true,
          title: Column(
            children: [
              Text(' " ${widget.book.bookName} " ', style: TextStyle(fontStyle: FontStyle.italic),),
              Text("Kitabına Ait Notlarınız: ")
            ],
          ),
        ),
        
        body: Padding(
          padding: const EdgeInsets.only(top:14.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: Icon(Icons.notes_sharp),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text('${notes[index].note}'),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.date_range_sharp),
                            SizedBox(width: 10,),
                            Text('${notes[index].date.toDate()}'),
                            SizedBox(width: 30,),
                            Icon(Icons.file_copy),
                            Text('${notes[index].page.toString()}')
                          ],
                        ),
                      );
                    }, 
                    separatorBuilder: (context, _) => Divider(), 
                    itemCount: notes.length
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Notes? newNote = 
                      await showModalBottomSheet<Notes>(
                        enableDrag: false,
                        isDismissible: false,
                        builder: (BuildContext context){
                          return WillPopScope(
                            onWillPop: () async {
                              return false;
                            },
                            child: NoteForm(),
                          );
                        },
                        context: context,
                      );
                      if(newNote != null){
                        setState(() {
                          notes.add(newNote);
                        });
                        context.read<OkunacakNotesListModel>().updateNote(
                          book: widget.book, noteList: notes
                        );
                      }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    color: Colors.brown[300],
                    child: Icon(Icons.add_circle,size: 30,),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

class NoteOkunmusList extends StatefulWidget {
  
  final OkunmusBook book;
  const NoteOkunmusList({Key? key, required this.book}) : super(key: key);
  @override
  _NoteOkunmusListState createState() => _NoteOkunmusListState();
}

class _NoteOkunmusListState extends State<NoteOkunmusList> {
  @override
  Widget build(BuildContext context) {

    List<Notes> notes = widget.book.notes;
    return  ChangeNotifierProvider<OkunmusNotesListModel>(
      create: (context)=>OkunmusNotesListModel(),
      
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          toolbarHeight: 80,
          centerTitle: true,
          title: Column(
            children: [
              Text(' " ${widget.book.bookName} " ', style: TextStyle(fontStyle: FontStyle.italic),),
              Text("Kitabına Ait Notlarınız: ")
            ],
          ),
        ),
        
        body: Padding(
          padding: const EdgeInsets.only(top:14.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: Icon(Icons.notes_sharp),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text('${notes[index].note}'),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.date_range_sharp),
                            SizedBox(width: 10,),
                            Text('${notes[index].date.toDate()}'),
                            SizedBox(width: 30,),
                            Icon(Icons.file_copy),
                            Text('${notes[index].page.toString()}')
                          ],
                        ),
                      );
                    }, 
                    separatorBuilder: (context, _) => Divider(), 
                    itemCount: notes.length
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Notes? newNote = 
                      await showModalBottomSheet<Notes>(
                        enableDrag: false,
                        isDismissible: false,
                        builder: (BuildContext context){
                          return WillPopScope(
                            onWillPop: () async {
                              return false;
                            },
                            child: NoteForm(),
                          );
                        },
                        context: context,
                      );
                      if(newNote != null){
                        setState(() {
                          notes.add(newNote);
                        });
                        context.read<OkunmusNotesListModel>().updateNote(
                          book: widget.book, noteList: notes
                        );
                      }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    color: Colors.brown[300],
                    child: Icon(Icons.add_circle,size: 30,),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}