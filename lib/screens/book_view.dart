import 'package:flutter/material.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/book_view_model.dart';
import 'package:my_library/models/notes_list_model.dart';
import 'package:my_library/models/notes_model.dart';
import 'package:my_library/screens/menu_yapimi.dart';
import 'package:my_library/screens/welcome_page.dart';
import 'package:my_library/services/auth.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';


class BookView extends StatefulWidget {
 //final _firebaseAuth = FirebaseAuth.instance;
  final Auth _auth = Auth();
  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
  @override

  Widget build(BuildContext context) {
     //var deviceH = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<OkunacakBookViewModel>(
      create: (_) => OkunacakBookViewModel(),
      builder: (context, child) => Scaffold(
        
        appBar: AppBar(
          backgroundColor: Colors.brown[100],
          actions: <Widget>[
            /*
            ElevatedButton.icon(
              onPressed: ()async{
                await widget._auth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
              }, 
              style: ElevatedButton.styleFrom(
                primary: Colors.brown[200],
              ),
              icon: Icon(Icons.logout, ), 
              label: Text('')
            )*/
          ],
        ),
        drawer: MenuYapimi(),
        backgroundColor: Colors.brown[50],
        body: Center(
          child: Column(
            children: [
              /*
              Positioned(
                top: 0,
                right: 5,
                child: Logout(deviceH * 0.015),
              ),*/
                StreamBuilder<List<OkunacakBook>>(
                  stream: Provider.of<OkunacakBookViewModel>(context, listen: false).getOkunacakBookList(),
                  builder: (context, asyncSnapshot) {
                    print(asyncSnapshot.error);
                    if(asyncSnapshot.hasError) {
                      return Center (
                        child: Text('Bir hata oluştu, daha sonra tekrar deneyiniz.'),
                      );
                    } else {
                      if(!asyncSnapshot.hasData){
                        return CircularProgressIndicator();
                      }else{
                        List<OkunacakBook> kitapList = asyncSnapshot.data!;
                        List<OkunacakBook> suanokunanlar = asyncSnapshot.data!.where((element) => element.nowReading==true).toList();
                        List<OkunacakBook> okunacaklar = asyncSnapshot.data!.where((element) => element.nowReading).toList();
                        return BuildListView(kitapList: kitapList, suanokunanlar: suanokunanlar, okunacaklar:okunacaklar,);
                      }
                    }
                  }
                ),
                Divider(),
              ],
            ),
          ),
        ),
    );
  }
}

class BuildListView extends StatefulWidget {
  
  const BuildListView({ Key? key, required this.kitapList, required this.suanokunanlar, required this.okunacaklar,  }) : super(key: key);

  final List<OkunacakBook> kitapList;
  final List<OkunacakBook> suanokunanlar;
  final List<OkunacakBook> okunacaklar;

  @override
  State<BuildListView> createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  bool isFiltering = false;
  double okunmusSayfa=0;
  late List<OkunacakBook> filteredList;

  //final FirebaseFirestore _database = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    //var fullList = widget.kitapList;
    var okunanKitap = widget.suanokunanlar;
    //var okunacakList = widget.okunacaklar;
    
    return ChangeNotifierProvider<OkunacakNotesListModel>(
      create: (context) => OkunacakNotesListModel(),
      builder: (context, _) => 
       Flexible(
          child: Column(
            children: [
              Container(
                
                padding: const EdgeInsets.only(right:30.0,left: 30.0, bottom: 10),
                decoration: new BoxDecoration(
                  color: Colors.brown[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                
                //color: Colors.limeAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 14),
                          child: Column(
                            children:[
                              Text('Okumaya', style: TextStyle(fontSize: 25, color: Colors.brown),),
                              SizedBox(height: 5,),
                              Text('Devam Et ....', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown),),
                            ]
                          ),
                        ),
                        SizedBox(width: 30,),
                        Image(image: AssetImage('assets/book.gif',),width: 100, height: 60,)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 180,
                            width: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(okunanKitap[0].photoUrl),fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              )
                            ),
                          ),
                        ),
                        SizedBox(width: 30,),
                        Expanded(
                         flex: 2,
                          child: Column( 
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             Padding(
                               padding: const EdgeInsets.only(left:40.0),
                               child: Text(okunanKitap[0].bookName,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                             ),
                              // Divider(
                              //   thickness: 3,
                              //   color: Colors.brown,
                              // ),
                              SizedBox(height: 10,),
                              Divider(
                                thickness: 1,
                                color: Colors.brown,
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //Icon(Icons.edit),
                                  SizedBox(width: 10,),
                                  Text(okunanKitap[0].authorName,style: TextStyle( fontSize: 20)),
                                ],
                              ),
                              SizedBox(height: 5,),
                              
                              SizedBox(height: 5,),
                              /*
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Kaç Sayfa Okudunuz?', style: TextStyle(fontSize: 15),),
                                      Icon(Icons.arrow_right),
                                      Text('${okunmusSayfa.round()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                    ],
                                  ),
                                  Slider(
                                    min: 0,
                                    max: okunanKitap[0].pageNumber.toDouble(),
                                    divisions: okunanKitap[0].pageNumber.toInt(),
                                    value: okunmusSayfa,
                                    onChanged: (double yeniOkunmusSayfa){
                                      setState(() {
                                        okunmusSayfa = yeniOkunmusSayfa;
                                      });
                                    },
                                  )
                                ],
                              )*/
                            ]
                          ),
                        )       
                      ]      
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:25.0, left: 40,),
                    child: Container(
                      padding: const EdgeInsets.only(right:30.0,left: 20.0),
                /*decoration: new BoxDecoration(
                  color: Colors.brown[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),*/
                      child: Column(
                        children:[
                          Text('Senin', style: TextStyle(fontSize: 25, color: Colors.brown),),
                          SizedBox(height: 5,),
                          Text('Notların ....', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown),),
                        ]
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Image(image: AssetImage('assets/note4.png'),width: 90, height: 50,)
                ],
              ), 
              SizedBox(height: 5,),
              Expanded(child: NotesList(book: okunanKitap[0],)),
              IconButton(
                onPressed: ()async{
                  Notes? newNotesInfo = 
                   await showModalBottomSheet<Notes>(
                     enableDrag: false,
                     isDismissible: false,
                     builder: (BuildContext context){
                       return WillPopScope(
                         onWillPop: ()async{
                           return false;
                         },
                         child: NoteForm(),
                       );
                     },
                     context: context,
                   );
                   if(newNotesInfo != null){
                     setState(() {
                       okunanKitap[0].notes.add(newNotesInfo);
                     });
                     context.read<OkunacakNotesListModel>().updateNote(
                       book: okunanKitap[0], noteList: okunanKitap[0].notes
                     );
                   }
                }, 
                iconSize: 30,
                icon: Icon(Icons.add_circle))
              // InkWell(
              //   onTap: () async {
              //     Notes? newNotesInfo = 
              //     await showModalBottomSheet<Notes>(
              //       enableDrag: false,
              //       isDismissible: false,
              //       builder: (BuildContext context){
              //         return WillPopScope(
              //           onWillPop: ()async{
              //             return false;
              //           },
              //           child: NoteForm(),
              //         );
              //       }
              //       context: context,
              //     );
              //     if(newNotesInfo != null){
              //       setState(() {
              //         okunanKitap[0].notes.add(newNotesInfo);
              //       });
              //       context.read<NotesListModel>().updateNote(
              //         book: okunanKitap[0], noteList: okunanKitap[0].notes
              //       );
              //     }
              //   },
              //   child: IconButton(
              //     iconSize: 30,
              //     onPressed: (){}, 
              //     icon: Icon(Icons.add_circle)
              //   ),
              // )
            ],
          ),
        
      ),
    ); 
  }
}

class NotesList extends StatefulWidget {
  
  final OkunacakBook book;
  const NotesList({Key? key, required this.book}) : super(key: key);
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {

    List<Notes> notes = widget.book.notes;
    return  ChangeNotifierProvider<OkunacakNotesListModel>(

      create: (context)=>OkunacakNotesListModel(),
      builder: (context, _) =>ListView.separated(
        itemBuilder: (context, index){
          return ListTile(
            
            leading: Icon(Icons.notes_sharp),
            title: Text('${notes[index].note}'),
          );
        }, 
        separatorBuilder: (context, _) => Divider(thickness: 3, color: Colors.brown[200],), 
        itemCount: notes.length,
      
        
      ),
    );
  }
}

class NoteForm extends StatefulWidget {

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  TextEditingController noteController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    noteController.dispose();
    pageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OkunacakNotesListModel(),
      builder: (context,_) => Container(
        color: Colors.brown[50],
        padding: EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        Image(
                          width: 80,
                          height: 80,
                          image: AssetImage('assets/notes.gif'),
                        ),
                        /*
                        Positioned(
                          bottom: -5,
                          right: -10,
                          child: IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.photo_camera_rounded,
                              color: Colors.grey.shade100,
                              size: 26,
                            ),
                          ),
                        )*/
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: noteController,
                          decoration: InputDecoration(
                            hintText: 'Not...',
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Not Ekleyiniz';
                            } else{
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: pageController,
                      decoration: InputDecoration(
                        hintText: 'Sayfa ?',
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Sayfa Belirleyiniz.';
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    child: TextFormField(
                      onTap: () async {
                        _selectedDate = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(-1000),
                          lastDate: DateTime.now().add(Duration(days: 365))
                        ))!;
                        dateController.text = 
                          Calculator.dateTimeToString(_selectedDate);
                      },
                      controller: dateController,
                      decoration: InputDecoration(
                        hintText: 'Not Tarihi',
                        prefixIcon: Icon(Icons.date_range)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen Tarih Belirleyiniz';
                        }else{
                          return null;
                        }
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[400]
                    ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        Notes newNote = Notes(
                          note: noteController.text, 
                          page: pageController.text, 
                          date: Calculator.datetimeToTimestamp(_selectedDate),
                        );
                        Navigator.pop(context, newNote);
                      }
                    },
                    child: Text('Yeni Not Ekle'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[400]
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    child: Text('İPTAL'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}