/*
import 'package:flutter/material.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/book_view_model.dart';
import 'package:my_library/screens/book_view.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';

class OkunacakBookDetail extends StatefulWidget {
  final OkunacakBook book;
  const OkunacakBookDetail({required this.book});

  @override
  _OkunacakBookDetailState createState() => _OkunacakBookDetailState();
}

class _OkunacakBookDetailState extends State<OkunacakBookDetail> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OkunacakBookViewModel>(
      create: (_) => OkunacakBookViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[100],
        ),
       
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
                        
                        final OkunacakBook book;
                        return  OkunacakDetay(kitapList: kitapList, book: book);
                        
                      }
                    }
                  }
                )
              ]
          ),
        ),
      )
          );
  }
}

class OkunacakDetay extends StatefulWidget {
  const OkunacakDetay({ Key? key, required this.kitapList, required this.book})  : super(key: key);
  final List<OkunacakBook> kitapList;
  final OkunacakBook book;

  @override
  State<OkunacakDetay> createState() => _OkunacakDetayState();
}

class _OkunacakDetayState extends State<OkunacakDetay> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OkunacakBookViewModel>(
      create: (_)=>OkunacakBookViewModel(),
      
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: Text('Kitap Detay Sayfası'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('${widget.book.bookName}')
                  ],
                )
              ],
            ),
          ),
        ),
      )
      
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/book_view_model.dart';
import 'package:my_library/screens/note_list_view.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';
//import 'package:palette_generator/palette_generator.dart';

class OkunacakBookDetail extends StatefulWidget {
  final OkunacakBook book;
  const OkunacakBookDetail({ required this.book });
  

  @override
  _OkunacakBookDetailState createState() => _OkunacakBookDetailState();
}

class _OkunacakBookDetailState extends State<OkunacakBookDetail> {
  /*
  List<PaletteColor> ?colors;

  @override
  void initState(){
    super.initState();
    colors = [];
    _updatePalettes();
  }

  _updatePalettes() async {
   final Future<PaletteGenerator> generator = 
    PaletteGenerator.fromImageProvider(
     AssetImage(widget.book.photoUrl),
   );
   colors!.add(generator.lightMutedColor != null ? 
    generator.lightMutedColor : PaletteColor(Colors.brown, 2));
  }
*/
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OkunacakBookViewModel>(
      create: (_) => OkunacakBookViewModel(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[200],
          title: Text("Kitap Detay Sayfası"),
          centerTitle: true,
          toolbarHeight: 70,
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: //Text('${widget.book.bookName}'),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 180,
                          child: Image(image: NetworkImage(widget.book.photoUrl), fit: BoxFit.cover,)
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Kitap Adı: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        Expanded(child: Text(widget.book.bookName,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),))
                      ],
                    ),
                  ),
                  Divider(height: 3,thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Yazar Adı: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        Expanded(child: Text(widget.book.authorName,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),))
                      ],
                    ),
                  ),
                  Divider(height: 3,thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sayfa Sayısı: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        Text(widget.book.pageNumber.toString(),style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                      ],
                    ),
                  ),
                  Divider(height: 3,thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Planlanan Okuma Tarihi: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        Text(Calculator.dateTimeToString(widget.book.plannedDate.toDate()),style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                      ],
                    ),
                  ),
                  Divider(height: 3,thickness: 2,),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/ok2.png'),width: 70,height: 80,),
                        SizedBox(width: 10,),
                        ElevatedButton(
                          child: Text('Bu Kitaba Ait Notların'),
                          onPressed: (){
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => 
                                NoteOkunacakList(book: widget.book)));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.brown[500]
                          ),
                        ),
                      ],
                    )
                  ),
                  
                ],
              ),
            )
          ),
      ),
    );
  }
}

class OkunmusBookDetail extends StatefulWidget {
  final OkunmusBook book;
  const OkunmusBookDetail({ required this.book });

  @override
  _OkunmusBookDetailState createState() => _OkunmusBookDetailState();
}

class _OkunmusBookDetailState extends State<OkunmusBookDetail> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OkunmusBookViewModel>(
      create: (_) => OkunmusBookViewModel(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Kitap Detay Sayfası'),
          centerTitle: true,
          toolbarHeight: 70,
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 180,
                        child: Image(image: NetworkImage(widget.book.photoUrl),fit: BoxFit.cover,),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Kitap Adı: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Expanded(child: Text(widget.book.bookName, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),))
                    ],
                  ),
                ),
                Divider(height: 3, thickness: 2,),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Yazar Adı: ' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Text(widget.book.authorName, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),)
                    ],
                  ),
                ),
                Divider(height: 3,thickness: 2,),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sayfa Sayısı: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Text(widget.book.pageNumber.toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),)
                    ],
                  ),
                ),
                Divider(height: 3,thickness: 2,),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Okuduğun Tarih: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Text(Calculator.dateTimeToString(widget.book.readDate.toDate()),style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),)
                    ],
                  ),
                ),
                Divider(height: 3,thickness: 2,),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/ok2.png'),width: 70,height: 80,),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        child: Text('Bu Kitaba Ait Notların'),
                        onPressed: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => 
                              NoteOkunmusList(book: widget.book)));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown[100]
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}