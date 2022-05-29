//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/book_view_model.dart';
import 'package:my_library/screens/add_book_view.dart';
import 'package:my_library/screens/book_detail_page.dart';
import 'package:my_library/screens/menu_yapimi.dart';
import 'package:my_library/screens/note_list_view.dart';
import 'package:my_library/screens/update_book_view.dart';
import 'package:provider/provider.dart';

class OkunacakKitaplar extends StatefulWidget {

  @override
  _OkunacakKitaplarState createState() => _OkunacakKitaplarState();
}

class _OkunacakKitaplarState extends State<OkunacakKitaplar> {
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<OkunacakBookViewModel>(
      create: (_) => OkunacakBookViewModel(),
      builder: (context, child) => Scaffold(
        drawer: MenuYapimi(),
        backgroundColor: Colors.brown[100],
        body: Center(
          
            child: Column(
              children: [
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
                        
                        return BuildOkunacaklarView(kitapList: kitapList);
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

class BuildOkunacaklarView extends StatefulWidget {
  const BuildOkunacaklarView({ Key? key, required this.kitapList }) : super(key: key);

  final List<OkunacakBook> kitapList;
  @override
  _BuildOkunacaklarViewState createState() => _BuildOkunacaklarViewState();
}

class _BuildOkunacaklarViewState extends State<BuildOkunacaklarView> {
  bool isFiltering=false;
  late List<OkunacakBook> filteredList;
  
  @override
  Widget build(BuildContext context) {
    var fullOkunacaklarList = widget.kitapList;
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset('assets/kütüphane4.jpg').image,
                  opacity: 0.4
                  //opacity: 0.7
                )
              ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:55.0),
                  child: Text('Okunacak Kitaplar Kütüphanesi', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                     
                ),
              ],
            ),
             Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
               child: 
                 TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Arama: Kitap Adı',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    onChanged: (query){
                      if(query.isNotEmpty){
                        isFiltering = true;
                        setState(() {
                          filteredList = fullOkunacaklarList.where((book) => book.bookName.toLowerCase().contains(query.toLowerCase())).toList();
                        });
                      }else{
                        WidgetsBinding.instance.focusManager.primaryFocus!.unfocus();
                        setState(() {
                          isFiltering = false;
                        });
                      }
                    },
                  ),
             ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: ListView.builder(
                    itemCount: isFiltering
                    ? filteredList.length
                    : fullOkunacaklarList.length,
                    itemBuilder: (context, index){
                      var okunacakList = isFiltering ? filteredList : fullOkunacaklarList;
                      //FirebaseStorage _storage= FirebaseStorage.instance;
                      //Reference refPhotos = _storage.ref().child('bookPhotos');
                      //var photoUrl = refPhotos.child('insanınmerakyolculuğu.jpg').getDownloadURL();
                      
                      return Slidable(
                        child: Card(
                          
                          color: Colors.black12,
                          
                          child: GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OkunacakBookDetail(
                                      book: okunacakList[index],
                                    ),
                                  )
                                );
                              } ,
                            child: ListTile(
                              leading: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                  maxHeight: 64,
                                  maxWidth: 64
                                ),
                                child: Image(image: NetworkImage(fullOkunacaklarList[index].photoUrl),fit: BoxFit.cover,)),
                              //leading: Image(image: AssetImage('assets/bookk.gif'),),
                              title: Text(okunacakList[index].bookName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(okunacakList[index].authorName, style: TextStyle(fontSize: 15),),
                                    Text('Sayfa Sayısı: ' + okunacakList[index].pageNumber.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: (){},
                          ),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.black45,
                              onPressed: (_){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateOkunacakBookView(
                                      book: okunacakList[index],
                                    ),
                                  )
                                );
                              },
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            
                            SlidableAction(
                              backgroundColor: Colors.red,
                              onPressed: (_)async{
                                await Provider.of<OkunacakBookViewModel>(context,listen: false).deleteBook(okunacakList[index]);
                              },
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: (){},
                          ),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.grey,
                              onPressed: (_){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => 
                                    NoteOkunacakList(book: okunacakList[index])));
                              },
                              icon: Icons.note_alt,
                              label: 'Notes',
                            )
                          ],
                        )
                      );
                    },
                  ),
                ),
              ),
            ),
            
            IconButton(
              iconSize: 35,
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddOkunacakBookView()));
              }, 
              icon: Icon(Icons.add_circle)
            )
          ],
        ),
          
        )
      );
      
  }
}