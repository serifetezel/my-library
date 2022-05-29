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

class OkunmusKitaplar extends StatefulWidget {
  
  @override
  _OkunmusKitaplarState createState() => _OkunmusKitaplarState();
}

class _OkunmusKitaplarState extends State<OkunmusKitaplar> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OkunmusBookViewModel>(
      create: (_) => OkunmusBookViewModel(),
      builder:(context, child) => Scaffold(
        drawer: MenuYapimi(),
        backgroundColor: Colors.brown[100],
        body: Center(
          child: Column(
            children: [
              StreamBuilder<List<OkunmusBook>>(
                stream: Provider.of<OkunmusBookViewModel>(context, listen: false).getOkunmusBookList(),
                builder: (context, asyncSnapshot) {
                  print(asyncSnapshot.error);
                  if(asyncSnapshot.hasError){
                    return Center (
                      child: Text('Bir hata oluştu, daha sonra tekrar deneyiniz.'),
                    );
                  }else{
                    if(!asyncSnapshot.hasData){
                      return CircularProgressIndicator();
                    }else{
                      List<OkunmusBook> kitapList = asyncSnapshot.data!;
                      return BuildOkunmuslarView(kitapList: kitapList);
                    }
                  }
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildOkunmuslarView extends StatefulWidget {
  const BuildOkunmuslarView({ Key? key, required this.kitapList}) : super(key: key);

  final List<OkunmusBook> kitapList;
  @override
  _BuildOkunmuslarViewState createState() => _BuildOkunmuslarViewState();
}

class _BuildOkunmuslarViewState extends State<BuildOkunmuslarView> {
  bool isFiltering = false;
  late List<OkunmusBook> filteredList;

  @override
  Widget build(BuildContext context) {
    var fullOkunmuslarList = widget.kitapList;
    //FirebaseStorage _storage= FirebaseStorage.instance;
    //Reference refPhotos = _storage.ref().child('bookPhotos');
    //var photoUrl = refPhotos.child('insanınmerakyolculuğu.jpg').getDownloadURL();
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset('assets/kütüphane4.jpg').image,
            opacity: 0.4
            //opacity: 0.9
          )
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 55.0),
                  child: Text('Okunmuş Kitaplar Kütüphanesi', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Arama: Kitap Adı: ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  )
                ),
                onChanged: (query){
                  if(query.isNotEmpty){
                    isFiltering = true;
                    setState(() {
                      filteredList = fullOkunmuslarList.where((book) => book.bookName.toLowerCase().contains(query.toLowerCase())).toList();
                    });
                  } else{
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
                    : fullOkunmuslarList.length,
                    itemBuilder: (context, index) {
                      var okunmusList = isFiltering ? filteredList : fullOkunmuslarList;
                      return Slidable(
                        child: Card(
                          color: Colors.black12,
                          child: GestureDetector(
                            onDoubleTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => OkunmusBookDetail(
                                  book: okunmusList[index],
                                )));
                            },
                            child: ListTile(
                              leading: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                  maxHeight: 64,
                                  maxWidth: 64
                                ),
                                child: Image(image: NetworkImage(fullOkunmuslarList[index].photoUrl),fit: BoxFit.cover,)),
                              title: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(okunmusList[index].bookName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(okunmusList[index].authorName, style: TextStyle(fontSize: 15),),
                                    Text('Sayfa Sayısı: ' + okunmusList[index].pageNumber.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
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
                                    builder: (context) => UpdateOkunmusBookView(
                                      book: okunmusList[index],
                                    )
                                  )
                                );
                              },
                              icon: Icons.edit,
                              label: 'Edit',
                            ),

                            SlidableAction(
                              backgroundColor: Colors.red,
                              onPressed: (_) async {
                                await Provider.of<OkunmusBookViewModel>(context, listen: false).deleteBook(okunmusList[index]);
                              },
                              icon: Icons.delete,
                              label: 'Delete',
                            )
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      NoteOkunmusList(book: okunmusList[index])
                                  )
                                );
                              },
                              icon: Icons.note_alt,
                              label: 'Notes',
                            )
                          ],
                        ),
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
                MaterialPageRoute(builder: (context) => AddOkunmusBookView()));
              },
              icon: Icon(Icons.add_circle),
            )
          ],
        ),
      ),
    );
  }
}