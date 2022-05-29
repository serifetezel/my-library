import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_library/screens/book_view.dart';
import 'package:my_library/screens/welcome_page.dart';
import 'package:my_library/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs = await SharedPreferences.getInstance();
   var email = prefs.getString('email');
  await Firebase.initializeApp();
  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {
  final email;
  const MyApp({ Key? key, required this.email, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (context) => Auth()),
        StreamProvider<QuerySnapshot?>(initialData: null,create: (_) => FirebaseFirestore.instance.collection('okunacak_kitaplar').snapshots()),
        StreamProvider<QuerySnapshot?>(initialData: null,create: (_) => FirebaseFirestore.instance.collection('okunmus_kitaplar').snapshots()),
        StreamProvider<QuerySnapshot?>(initialData: null,create: (_) => FirebaseFirestore.instance.collection('senin_notların').snapshots())
      ],
      child: Consumer<Auth>(
       builder: (ctx,auth,_)=> MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Library',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        
        home: email == null ? WelcomePage() : BookView(),
        //home: WelcomePage(),
      ),
     )
    );
  }
}

