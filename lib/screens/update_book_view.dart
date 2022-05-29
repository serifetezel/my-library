import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_library/models/book_model.dart';
import 'package:my_library/models/update_book_view_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';

class UpdateOkunacakBookView extends StatefulWidget {
  
  final OkunacakBook book;
  const UpdateOkunacakBookView({required this.book});

  @override
  _UpdateOkunacakBookViewState createState() => _UpdateOkunacakBookViewState();
}

class _UpdateOkunacakBookViewState extends State<UpdateOkunacakBookView> {

  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController plannedController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _selectedDate;
  String ?_photoUrl;
  File ?_image;

  final picker = ImagePicker();

  Future pickImages() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<String?> uploadFile() async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .putFile(file);

      return await uploadFile.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
  }
  @override
  void dispose(){
    bookController.dispose();
    authorController.dispose();
    pageController.dispose();
    plannedController.dispose();
    super.dispose();
  }
  bool readController = false;
  @override
  void initState() {
    super.initState();
    bookController.text = widget.book.bookName;
    authorController.text = widget.book.authorName;
    pageController.text = widget.book.pageNumber.toString();
    plannedController.text = Calculator.dateTimeToString(
      Calculator.datetimeFromTimestamp(widget.book.plannedDate)
    );
    readController =  widget.book.nowReading;
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateOkunacakBookViewModel>(
      create: (_) => UpdateOkunacakBookViewModel(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          title: Text("Kitap Bilgisi Güncelle"),
          centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: bookController,
                      decoration: InputDecoration(
                        hintText: 'Kitap Adı:',
                        icon: Icon(Icons.book),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Kitap Adı Boş Bırakılamaz.';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: authorController,
                      decoration: InputDecoration(
                        hintText: 'Yazar Adı:',
                        icon: Icon(Icons.edit), 
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Yazar Adı Boş Bırakılamaz';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Kitap Sayfa Sayısı:',
                        icon: Icon(Icons.file_copy),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Kitap Sayfa Sayısı Boş Bırakılamaz.';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      onTap: () async {
                        _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 1095))
                        );
                        plannedController.text = Calculator.dateTimeToString(_selectedDate!);
                      },
                      controller: plannedController,
                      decoration: InputDecoration(
                        hintText: 'Planlanan Okuma Tarihi',
                        icon: Icon(Icons.date_range)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen Tarih Belirleyiniz';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              width: 100,
                              child: (_image == null)
                              ? Image(image: NetworkImage(widget.book.photoUrl)) //Image(image: AssetImage('assets/kamera2.png'))
                              : Image.file(_image!),
                              
                            ),
                            Positioned(
                              bottom: -5,
                              right: -10,
                              child: IconButton(
                                onPressed: pickImages,
                                icon: Icon(Icons.photo_camera_rounded,
                                color: Colors.black54,
                                size: 26,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Şu anda okuyorum   -->', style: TextStyle(fontSize: 18),),
                        Checkbox(
                          value:readController,
                          onChanged: (value) {
                            setState(() {
                              readController = !readController;
                            });
                          },
                        ),
                      ],
                    ),
                    //Text(readController.toString()) //
              
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown[400],
                        minimumSize: Size(100, 50)
                      ),
                      onPressed: ()async{
                        //var imagePath = await uploadFile();
                        if(_formKey.currentState!.validate()){
                          await context.read<UpdateOkunacakBookViewModel>().updateOkunacakBook(
                            bookName: bookController.text, 
                            authorName: authorController.text, 
                            photoUrl:  _photoUrl ?? widget.book.photoUrl, 
                            plannedDate: _selectedDate ?? Calculator.datetimeFromTimestamp(widget.book.plannedDate), 
                            nowReading: readController, 
                            pageNumber: int.parse(pageController.text), 
                            book: widget.book
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text('GÜNCELLE'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

class UpdateOkunmusBookView extends StatefulWidget {
  
  final OkunmusBook book;
  const UpdateOkunmusBookView({required this.book});

  @override
  _UpdateOkunmusBookViewState createState() => _UpdateOkunmusBookViewState();
}

class _UpdateOkunmusBookViewState extends State<UpdateOkunmusBookView> {

  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController readDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _selectedDate;
  String ?_photoUrl;
  File ?_image;

  final picker = ImagePicker();

  Future pickImages() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<String?> uploadFile() async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .putFile(file);

      return await uploadFile.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose(){
    bookController.dispose();
    authorController.dispose();
    pageController.dispose();
    readDateController.dispose();
    super.dispose();
  }
  bool readController = false;
  @override
  void initState() {
    super.initState();
    bookController.text = widget.book.bookName;
    authorController.text = widget.book.authorName;
    pageController.text = widget.book.pageNumber.toString();
    readDateController.text = Calculator.dateTimeToString(
      Calculator.datetimeFromTimestamp(widget.book.readDate)
    );
    readController =  widget.book.nowReading;
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateOkunmusBookViewModel>(
      create: (_) => UpdateOkunmusBookViewModel(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          title: Text("Kitap Bilgisi Güncelle"),
          centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: bookController,
                      decoration: InputDecoration(
                        hintText: 'Kitap Adı:',
                        icon: Icon(Icons.book),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Kitap Adı Boş Bırakılamaz.';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: authorController,
                      decoration: InputDecoration(
                        hintText: 'Yazar Adı:',
                        icon: Icon(Icons.edit), 
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Yazar Adı Boş Bırakılamaz';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Kitap Sayfa Sayısı:',
                        icon: Icon(Icons.file_copy),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Kitap Sayfa Sayısı Boş Bırakılamaz.';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      onTap: () async {
                        _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(-1000),
                          lastDate: DateTime.now()
                        );
                        readDateController.text = Calculator.dateTimeToString(_selectedDate!);
                      },
                      controller: readDateController,
                      decoration: InputDecoration(
                        hintText: 'Planlanan Okuma Tarihi',
                        icon: Icon(Icons.date_range)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen Tarih Belirleyiniz';
                        }else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              width: 100,
                              child: (_image == null)
                              ? Image(image: NetworkImage(widget.book.photoUrl))
                              : Image.file(_image!),
                              
                            ),
                            Positioned(
                              bottom: -5,
                              right: -10,
                              child: IconButton(
                                onPressed: pickImages,
                                icon: Icon(Icons.photo_camera_rounded,
                                color: Colors.black87,
                                size: 26,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Şu anda okuyorum   -->', style: TextStyle(fontSize: 18),),
                        Checkbox(
                          value:readController,
                          onChanged: (value) {
                            setState(() {
                              readController = !readController;
                            });
                          },
                        ),
                      ],
                    ),
                    //Text(readController.toString()) //
              
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown[400],
                        minimumSize: Size(100, 50)
                      ),
                      onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          await context.read<UpdateOkunmusBookViewModel>().updateOkunmusBook(
                            bookName: bookController.text, 
                            authorName: authorController.text, 
                            photoUrl:  _photoUrl ?? widget.book.photoUrl, 
                            readDate: _selectedDate ?? Calculator.datetimeFromTimestamp(widget.book.readDate), 
                            nowReading: readController, 
                            pageNumber: int.parse(pageController.text), 
                            book: widget.book
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text('GÜNCELLE'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}