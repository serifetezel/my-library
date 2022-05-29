import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_library/screens/sign_in_page.dart';
import 'package:my_library/services/auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {

   
    final _registerFormKey = GlobalKey<FormState>();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();

    return Scaffold(
      
      backgroundColor: Colors.brown[100],
        body:  Center(
               
              child: SingleChildScrollView(
                child: Padding(
                  
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('KAYIT FORMU', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                            SizedBox(width: 100,),
                            Image(image: AssetImage('assets/bookgif.gif',),width: 90, height: 90,)
                          ],
                        ),
                        SizedBox(height: 30,),
                         TextFormField(
                           controller: _nameController,
                           decoration: InputDecoration(
                             hintText: 'Name',
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                           ),
                         ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _emailController,
                          validator: (value){
                            if(!EmailValidator.validate(value!)){
                                return 'Lütfen Geçerli Bir Mail Adresi Giriniz.';
                              }else{
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'E-mail',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value){
                            if(value!.length<6){
                              return 'Şifreniz en az 6 karakter olmalıdır';
                            }else{
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Şifre',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _passwordConfirmController,
                          validator: (value){
                            if(value!=_passwordController.text){
                              return 'Şifreler Uyuşmuyor';
                            }else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Onay',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        SizedBox(height: 30,),
                        ElevatedButton(
                          onPressed: ()async{
                             try{
                               if(_registerFormKey.currentState!.validate()){
                                 final user = await Provider.of<Auth>(context,listen: false).createUserWithEmailAndPassword(_nameController.text, _emailController.text,_passwordController.text);
                                 if(!user!.emailVerified){
                                   await user.sendEmailVerification();
                                 }
                                 await _showMyDialog();
                                 await Provider.of<Auth>(context, listen: false).signOut();
                                 setState(() {
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInPage()));
                                 });
                               }
                             }
                             on FirebaseAuthException catch(e){
                               print('Kayıt formu içerisinde hata yakalandı, ${e.message}');
                             }
                  
                            // if (_nameController.text.isNotEmpty &&
                            //   _emailController.text.isNotEmpty &&
                            //   _passwordController.text.isNotEmpty) {
                            //   final user = await Provider.of<Auth>(context,listen: false).createUserWithEmailAndPassword( _nameController.text,_emailController.text,_passwordController.text);
                            //   if(!user!.emailVerified){
                            //     await user.sendEmailVerification();
                            //   }
                            //   await _showMyDialog();
                            //   await Provider.of<Auth>(context, listen: false).signOut();
                            //   setState(() {
                            //     Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                            //   });
                        
                            // } else {
                            // print("Please enter Fields");
                            // }
                          },
                          child: Icon(Icons.check, size: 30,),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(80, 50),
                          ),
                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));  
                          },
                          child: Text('Zaten Üye misiniz? Tıklayınız!'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
  Future<void> _showMyDialog()async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: 
                const <Widget> [
                  Text('Merhaba, lütfen mailinizi kontrol ediniz.'),
                  Text('Onay linkini tıklayıp tekrar giriş yapabilirsiniz.'),
                ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}