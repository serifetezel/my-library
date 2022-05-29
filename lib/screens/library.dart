import 'package:flutter/material.dart';
import 'package:my_library/screens/okunacak_kitaplar.dart';
import 'package:my_library/screens/okunmus_kitaplar.dart';

class MyLibrary extends StatefulWidget {
 
  @override
  _MyLibraryState createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('MY LIBRARY', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
              Divider(thickness: 3,),
              SizedBox(height: 40,),
              Container(
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          //Image(image: AssetImage('assets/okunacaklar2.jpg',),width: 150, height: 90,),
                           CircleAvatar(
                            backgroundImage: 
                              AssetImage('assets/okunacaklar8.jpg'),
                              radius: 40,
                    ),
                    SizedBox(height: 5,),
                          Container(
                            width: 180,
                            
      //                child: MaterialButton(
                             
      //   padding: EdgeInsets.all(8.0),
      //   textColor: Colors.white,
      //   splashColor: Colors.greenAccent,
      //   elevation: 8.0,
      //   child: Container(
      //     width: 180,
      //     height: 200,
      //     decoration: BoxDecoration(
            
      //       image: DecorationImage(
      //           image: AssetImage('assets/register2.jpg'),
      //           fit: BoxFit.cover),
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.all(2.0),
      //       child: Text("OKUNACAK KİTAPLAR", style: TextStyle(color: Colors.black),),
      //     ),
      //   ),
      //   // ),
      //   onPressed: () {
      //     print('Tapped');
      //   },
      // ),
                             child:  ElevatedButton(
                               child: Text('OKUNACAK KİTAPLAR'),
                               onPressed: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => OkunacakKitaplar()));
                               },
                               style: ElevatedButton.styleFrom(
                                 fixedSize: const Size(50, 200),
                                 primary: Colors.brown[300]
                               ),
                               ),
                          ),
                        ],
                      ),
                      VerticalDivider(thickness: 3,),

                      Column(
                        children: [
                          //Image(image: AssetImage('assets/okunmuşlar2.jpg',),width: 150, height: 90,),
                          
                          CircleAvatar(
                            backgroundImage: 
                              AssetImage('assets/okunmuşlar.jpg',),
                              radius: 40,
                    ),
                    SizedBox(height: 5,),
                          Container(
                             width: 180,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 200),
                                primary: Colors.brown[300]
                              ),
                              child: Text('OKUNAN KİTAPLAR'),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OkunmusKitaplar()));
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],

          ),
        ),
      )
    );
  }
}