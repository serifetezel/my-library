import 'package:flutter/material.dart';
import 'package:my_library/screens/book_view.dart';
import 'package:my_library/screens/register_page.dart';
import 'package:my_library/screens/sign_in_with_email_page.dart';
import 'package:my_library/widgets/my_elevated_button.dart';

class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         Provider.of<Auth>(context, listen:false).signOut();
      //       },
      //       icon: Icon(Icons.logout),
      //     )
      //   ],
      // ),
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('SIGN IN WITH ...', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(width: 50,),
                  Image(image: AssetImage('assets/soru_işareti_gif.gif',),width: 40, height: 90,)
                ],
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left:12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: 
                        AssetImage('assets/email2.jpg'),
                    ),
                    SizedBox(width: 5,),
                    MyElevatedButton(
                      color:Colors.black54,
                      
                      child: Text('Sign In With Email/Password'),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EmailSignInPage()));
                      },
                      
                    ),
                  ],
                ),
              ),
              SizedBox(height:10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: 
                        AssetImage('assets/google.jpg'),
                    ),
                    SizedBox(width: 5,),
                    MyElevatedButton(
                      color: Colors.black54,
                      onPressed: ()async{
                        //final user = await Provider.of<Auth>(context, listen: false).signInWithGoogle();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BookView()));
                      }, 
                      child: Text('Sign In With Google')
                    ),
                  ],
                ),
                
              ),
              SizedBox(height: 10,),
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text('Yeni Bir Kayıt Oluşturmak İçin Tıklayın'),
              )
            ],
          ),
        ),
      ),
    );
  }
}