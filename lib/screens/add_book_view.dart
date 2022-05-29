import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_library/models/add_book_view_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';

class AddOkunacakBookView extends StatefulWidget {
  const AddOkunacakBookView({ Key? key }) : super(key: key);

  @override
  _AddOkunacakBookViewState createState() => _AddOkunacakBookViewState();
}

class _AddOkunacakBookViewState extends State<AddOkunacakBookView> {

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
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print('No image selected');
      }
    });
    if(pickedFile != null){
      _photoUrl = await uploadFile(_image!);
    }
  }

  Future<String?> uploadFile(File imageFile) async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg')
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddOkunacakBookViewModel>(
      create: (_) => AddOkunacakBookViewModel(),
      builder: (context, _) => Scaffold(
        
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[200],
          title: Column(
            children: [
              Text('Okunacak Kitaplar Listesine', style: TextStyle(fontStyle: FontStyle.italic),),
              Text("Yeni Kitap Ekle")
            ],
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Container(
            
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
                        hintText: 'Kitap Adı: ',
                        icon: Icon(Icons.book),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen ekleyeceğiniz kitabın adını doldurunuz';
                        }else{
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: authorController,
                      decoration: InputDecoration(
                        hintText: 'Kitap Yazar Adı: ',
                        icon: Icon(Icons.edit),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen ekleyeceğiniz kitabın yazar adını doldurunuz';
                        }else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Kitap Sayfa Sayısı: ',
                        icon: Icon(Icons.file_copy),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                           return 'Lütfen ekleyeceğiniz kitabın sayfa sayısını doldurunuz';
                        }else{
                          return null;
                        }
                      }
                    ),
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
                        hintText: 'Planlanan Okuma Tarihi: ',
                        icon: Icon(Icons.date_range)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen planladığınız okuma tarihini doldurunuz';
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
                              height: 100,
                              width: 80,
                              child: (_image == null)
                              ? Image(image: AssetImage('assets/kamera2.png'))
                              : Image.file(_image!),
                              
                            ),
                            Positioned(
                              bottom: -5,
                              right: -10,
                              child: IconButton(
                                onPressed: pickImages,
                                icon: Icon(Icons.photo_camera_rounded,
                                color: Colors.grey.shade100,
                                size: 26,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Şu anda bu kitabı mı okuyorsunuz ?', style: TextStyle(fontSize: 18)),
                        Checkbox(
                          value: readController, 
                          onChanged: (value) {
                            setState(() {
                              readController = !readController;
                            });
                          }
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown[300]
                      ),
                      onPressed: () async {
                        
                        if(_formKey.currentState!.validate()){
                          await context.read<AddOkunacakBookViewModel>().addOkunacakNewBook(
                            bookName: bookController.text, 
                            authorName: authorController.text,
                            photoUrl:  _photoUrl , 
                            plannedDate: _selectedDate, 
                            nowReading: readController, 
                            pageNumber: int.parse(pageController.text),
                          );
                          Navigator.pop(context);
                        }
                      }, 
                      child: Text('KAYDET')
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class AddOkunmusBookView extends StatefulWidget {
  const AddOkunmusBookView({ Key? key }) : super(key: key);

  @override
  _AddOkunmusBookViewState createState() => _AddOkunmusBookViewState();
}

class _AddOkunmusBookViewState extends State<AddOkunmusBookView> {

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
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print('No image selected');
      }
    });
    if(pickedFile != null){
      _photoUrl = await uploadFile(_image!);
    }
  }

  Future<String?> uploadFile(File imageFile) async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg')
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddOkunmusBookViewModel>(
      create: (_) => AddOkunmusBookViewModel(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[200],
          title: Column(
            children: [
              Text('Okunmuş Kitaplar Listesine', style: TextStyle(fontStyle: FontStyle.italic),),
              Text("Yeni Kitap Ekle")
            ],
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Container(
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
                        hintText: 'Kitap Adı: ',
                        icon: Icon(Icons.book),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen ekleyeceğiniz kitabın adını doldurunuz';
                        }else{
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: authorController,
                      decoration: InputDecoration(
                        hintText: 'Kitap Yazar Adı: ',
                        icon: Icon(Icons.edit),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen ekleyeceğiniz kitabın yazar adını doldurunuz';
                        }else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Kitap Sayfa Sayısı: ',
                        icon: Icon(Icons.file_copy),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                           return 'Lütfen ekleyeceğiniz kitabın sayfa sayısını doldurunuz';
                        }else{
                          return null;
                        }
                      }
                    ),
                    TextFormField(
                      onTap: () async {
                        _selectedDate = await showDatePicker(
                          context: context, 
                          initialDate: DateTime.now(), 
                          firstDate: DateTime(-1000), 
                          lastDate: DateTime.now(),
                        );
                        readDateController.text = Calculator.dateTimeToString(_selectedDate!);
                      },
                      controller: readDateController,
                      decoration: InputDecoration(
                        hintText: 'Okuduğunuz Tarih: ',
                        icon: Icon(Icons.date_range)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen planladığınız okuma tarihini doldurunuz';
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
                              height: 100,
                              width: 80,
                              child: (_image == null)
                              ? Image(image: AssetImage('assets/kamera2.png'))
                              : Image.file(_image!),
                              
                            ),
                            Positioned(
                              bottom: -5,
                              right: -10,
                              child: IconButton(
                                onPressed: pickImages,
                                icon: Icon(Icons.photo_camera_rounded,
                                color: Colors.grey.shade100,
                                size: 26,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Şu anda bu kitabı mı okuyorsunuz ?', style: TextStyle(fontSize: 18)),
                        Checkbox(
                          value: readController, 
                          onChanged: (value) {
                            setState(() {
                              readController = !readController;
                            });
                          }
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown[300]
                      ),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          await context.read<AddOkunmusBookViewModel>().addOkunmusNewBook(
                            bookName: bookController.text, 
                            authorName: authorController.text, 
                            photoUrl: _photoUrl,
                            readDate: _selectedDate, 
                            nowReading: readController, 
                            pageNumber: int.parse(pageController.text),
                          );
                          //Navigator.pop(context, MaterialPageRoute(builder: (context) => OkunmusKitaplar()));
                          Navigator.pop(context);
                        }
                      }, 
                      child: Text('KAYDET')
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}