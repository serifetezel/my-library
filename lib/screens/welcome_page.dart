import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_library/screens/register_page.dart';
import 'package:my_library/screens/sign_in_page.dart';

class WelcomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageSlideshow(
            width: double.infinity,
            height: double.infinity,
            initialPage: 0,
            children: [
              Image.asset(
                'assets/library1.jpg',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/library3.jpg',
                fit: BoxFit.cover
              )
            ],
            autoPlayInterval: 0,
           
          ),
          Positioned(
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
             children: [
               Padding(
                 padding: const EdgeInsets.only(left: 100, bottom: 60),
                 child: Column(
                   children: [
                     Text('MY', style: TextStyle(
                       color: Colors.white70, 
                       fontSize: 50, 
                       fontWeight: FontWeight.bold,),),
                     SizedBox(height: 40,),
                     Text('LIBRARY',style: TextStyle(
                       color: Colors.white70, 
                       fontSize: 50, 
                       fontWeight: FontWeight.bold)),
                   ],
                 ),
               ),
             ],
          ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              
             children: [
               
               Padding(
                 padding: const EdgeInsets.only(left: 40, bottom: 25, ),
                 child: Column(
                   children: [
                     
                     Row(
                       children: [
                         ElevatedButton(
                           
                           style: ElevatedButton.styleFrom(
                             primary: Colors.black54,
                             fixedSize: const Size(150, 60),
                             shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                           onPressed: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                           },
                           child: Text(
                             'CREATE ACCOUNT', 
                             textAlign: TextAlign.center,
                             style: TextStyle(color: Colors.white),
                             ),
                         ),

                         SizedBox(width: 40,),
                         ElevatedButton(
                           style: ElevatedButton.styleFrom(
                             primary: Colors.black54,
                             fixedSize: const Size(150, 60),
                             shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                           onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                           },
                           child: Text(
                             'LOGIN', 
                             textAlign: TextAlign.center,
                             style: TextStyle(color: Colors.white),
                            ),
                         ),
                       ],
                     )
                   ],
                 ),
               )
             ],
            ),
          )
        ],
      ),
    );
  }
}