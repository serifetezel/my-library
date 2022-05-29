import 'package:flutter/material.dart';
import 'package:my_library/models/senin_notlar%C4%B1n_model.dart';
import 'package:my_library/models/update_senin_notlarin_view_model.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';

class UpdateSeninNotunView extends StatefulWidget {
  final SeninNotlarin note;
  const UpdateSeninNotunView({ required this.note });

  @override
  State<UpdateSeninNotunView> createState() => _UpdateSeninNotunViewState();
}

class _UpdateSeninNotunViewState extends State<UpdateSeninNotunView> {

  TextEditingController notController = TextEditingController();
  TextEditingController tarihController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _selectedDate;

  @override
  void dispose(){
    notController.dispose();
    tarihController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    notController.text = widget.note.not;
    tarihController.text = Calculator.dateTimeToString(
      Calculator.datetimeFromTimestamp(widget.note.tarih)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateSeninNotlarinViewModel>(
      create: (_) => UpdateSeninNotlarinViewModel(),
      builder: (context, _) => Scaffold(
        
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[100],
          title: Text('Notunu Güncelle'),
          centerTitle: true,
        ),
        body: Padding(
          
          padding: const EdgeInsets.only(top:150.0),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 1,
                      controller: notController,
                      decoration: InputDecoration(
                        hintText: 'Notun ...',
                        icon: Icon(Icons.edit),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                            return 'Kitap Adı Boş Bırakılamaz.';
                          }else {
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
                        tarihController.text = Calculator.dateTimeToString(_selectedDate);
                      },
                      controller: tarihController,
                      decoration: InputDecoration(
                        hintText: 'Tarih Bilgisi -> DD/MM/YYYY',
                        icon: Icon(Icons.date_range),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen notunuz için tarih bilgisi giriniz';
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 60,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.brown[200],
                          minimumSize: Size(40, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          await context.read<UpdateSeninNotlarinViewModel>().updateSeninNotlarin(
                            not: notController.text, 
                            tarih: _selectedDate ?? Calculator.datetimeFromTimestamp(widget.note.tarih), 
                            note: widget.note
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
      ),
    );
  }
}