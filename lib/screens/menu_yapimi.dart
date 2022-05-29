import 'package:flutter/material.dart';
import 'package:my_library/screens/book_view.dart';
import 'package:my_library/screens/library.dart';
import 'package:my_library/screens/senin_notlarin_view.dart';
import 'package:my_library/screens/welcome_page.dart';
import 'package:my_library/services/auth.dart';

class MenuYapimi extends StatefulWidget {
  final Auth _auth = Auth();
 
  @override
  _MenuYapimiState createState() => _MenuYapimiState();
}

class _MenuYapimiState extends State<MenuYapimi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown[300],
            title: Text('Menü'),
            centerTitle: false,
          ),
          body: Drawer(
            backgroundColor:Colors.brown[50],
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  
                  decoration: BoxDecoration(
                    
                    color: Colors.brown[200], 
                    image: DecorationImage(
                      image: AssetImage('assets/bookgiff.gif'),
                      fit: BoxFit.scaleDown, 
                      alignment: Alignment.centerRight, 
                      scale: 4
                    ), borderRadius: BorderRadius.only(
                    //bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),),
                  accountName: Text('Merhaba !',
                  
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black
                    ),
                  ),
                  accountEmail: Text(
                    "Hoşgeldiniz",
                    style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 50,),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.home,
                        ),
                        title: Text("ANASAYFA"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BookView()));
                        },
                      ),
                      ListTile(
                          leading: Icon(Icons.book_online),
                          title: Text("KÜTÜPHANELER"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyLibrary()));
                          }
                      ),
                       ListTile(
                          leading: Icon(Icons.edit),
                          title: Text("NOTLAR"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotView()));
                          }
                      ),
                      ListTile(
                          leading: Icon(Icons.book),
                          title: Text("BENİM KİTABIM"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {}
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  height: 60,
                  
                  child: ElevatedButton.icon(
                  onPressed: ()async{
                await widget._auth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
              }, 
              style: ElevatedButton.styleFrom(
                primary: Colors.brown[200],
              ),
              icon: Icon(Icons.logout, ), 
              label: Text('Çıkış Yap',style: TextStyle(fontSize: 16),)
            ),
                )
              ],
            ),
          ),
        
    );
  }
}