import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_library/screens/book_view.dart';
import 'package:my_library/services/auth.dart';
import 'package:provider/provider.dart';

enum FormStatus {signIn, reset}

class EmailSignInPage extends StatefulWidget {
 
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {

  FormStatus _formStatus = FormStatus.signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Center(
        child: _formStatus == FormStatus.signIn
        ? buildSignInForm()
        : buildResetForm(),
      ),
    );
  }

  Widget buildSignInForm(){

    final _signInFormKey = GlobalKey<FormState>();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _signInFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('LOGIN PAGE', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(width: 100,),
                  Image(image: AssetImage('assets/bookgif.gif',),width: 90, height: 90,)
                ],
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: _nameController,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Lütfen İsim Alanını Boş Bırakmayınız';
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _passwordController,
                validator: (value){
                  if(value!.length<6){
                    return 'Şifreniz en az 6 karakterden oluşmalıdır.';
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
              SizedBox(height:20),
               ElevatedButton(
                 onPressed: ()async{
                   if(_signInFormKey.currentState!.validate()){
                     final response = await Provider.of<Auth>(context, listen: false).signInWithEmailAndPassword(_nameController.text, _emailController.text, _passwordController.text);
                     if(response['status']){
                       final user = response['user'];
                        if(!user!.emailVerified){
                          //await Provider.of<Auth>(context,listen: false).signOut();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BookView()));
                        }
                        }else{
                          print(response['message']);
                            Fluttertoast.showToast(
                              msg: 'Hatalı Şifre Girdiniz',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.black,
                              fontSize: 20.0
                            );
                     }
                    
                   }
                 },
                 child: Text('Giriş'),
                 style: ElevatedButton.styleFrom(
                  fixedSize: const Size(80, 50),
              )
               ),
               SizedBox(height: 10,),
               TextButton(
                 onPressed: (){
                   setState(() {
                     _formStatus = FormStatus.reset;
                   });
                 },
                 child: Text('Şifremi Unuttum !'),
               )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResetForm(){
    final _resetFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('ŞİFRE YENİLEME', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(width: 50,),
                  Image(image: AssetImage('assets/şifre_yenileme3.png',),width: 90, height: 90,)
                ],
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _emailController,
              validator: (value){
                if(!EmailValidator.validate(value!)){
                  return 'Lütfen Geçerli Bir Mail Adresi Giriniz';
                }else{
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'E-mail',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: ()async{
                if(_resetFormKey.currentState!.validate()){
                  await Provider.of<Auth>(context, listen: false).sendPasswordResetEmail(_emailController.text);
                  await _showResetPasswordDialog();
                  Navigator.pop(context);
                }

              },
              child: Text('Gönder'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(90, 50),
              )
            )
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog()async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget> [
                  Text('Merhaba, lütfen mailinizi kontrol ediniz'),
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

  Future<void> _showResetPasswordDialog()async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, lütfen mailinizi kontrol ediniz.'),
                Text('Linki tıklayarak şifrenizi yenileyebilirsiniz'),
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