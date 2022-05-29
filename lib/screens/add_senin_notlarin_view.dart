import 'package:flutter/material.dart';
import 'package:my_library/models/add_senin_notlarin_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';

class NotEkle extends StatefulWidget {

  @override
  _NotEkleState createState() => _NotEkleState();
}

class _NotEkleState extends State<NotEkle> {
  TextEditingController notController = TextEditingController();
  TextEditingController tarihController = TextEditingController();

  var _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    notController.dispose();
    tarihController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddSeninNotlarinModel>(
      create: (_) => AddSeninNotlarinModel(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[100],
          toolbarHeight: 80,
          title: Column(
            children: [
              Text('Kendin İçin',style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
              Text('Yeni Not Ekle ...',style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
              
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Container(

            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/page2.jpg').image,
                fit: BoxFit.fill
              )
            ),
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left:30, top: 62, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                         keyboardType: TextInputType.multiline,
                         maxLines: null,
                         minLines: 1,
                        controller: notController,
                        decoration: InputDecoration(
                          hintText: 'Notunuz ...',
                          icon: Icon(Icons.edit),
                          //border: OutlineInputBorder(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                    //)
                        ),
                        
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Lütfen ekleyeceğiniz not metnini giriniz.';
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 35,),
                      TextFormField(
                        onTap: ()async{
                          _selectedDate = await showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(), 
                            firstDate: DateTime(-1000), 
                            lastDate: DateTime.now().add(Duration(days: 1095))
                          );
                          tarihController.text = Calculator.dateTimeToString(_selectedDate!);
                        },
                        controller: tarihController,
                        decoration: InputDecoration(
                          hintText: 'Tarih Bilgisi -> DD/MM/YYYY',
                          icon: Icon(Icons.date_range),
                          //border: OutlineInputBorder(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                        //),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Lütfen notunuz için tarih bilgisi giriniz';
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 280,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown[200],
                          minimumSize: Size(40, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        
                        onPressed: ()async{
                          if(_formKey.currentState!.validate()){
                            await context.read<AddSeninNotlarinModel>().addSeninNotlarinNewNot(
                              not: notController.text, 
                              tarih: _selectedDate,
                            );
                            Navigator.pop(context);
                          }
                        }, 
                        child: Text('NOTUNU KAYDET')
                      )
                    ],
                    
                  ),
                  
                ),
              ),
            ),
          )
          ),
        ),
      );
    
  }
} 