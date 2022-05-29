import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_library/models/senin_notlar%C4%B1n_model.dart';
import 'package:my_library/models/senin_notlar%C4%B1n_view_model.dart';
import 'package:my_library/screens/add_senin_notlarin_view.dart';
import 'package:my_library/screens/update_senin_notun_view.dart';
import 'package:my_library/services/calculator.dart';
import 'package:provider/provider.dart';

class NotView extends StatefulWidget {

  @override
  _NotViewState createState() => _NotViewState();
}

class _NotViewState extends State<NotView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SeninNotlarinViewModel>(
      create: (_) => SeninNotlarinViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[100],
          title: Text('Senin Notların ... ', style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),),
          toolbarHeight: 70,
        ),
        backgroundColor: Colors.brown[100],
        body: Center(
          child: Column(
            children: [
              StreamBuilder<List<SeninNotlarin>>(
                stream: Provider.of<SeninNotlarinViewModel>(context, listen: false).getSeninNotlarinList(),
                builder: (context, asyncSnapshot) {
                  print(asyncSnapshot.error);
                  if(asyncSnapshot.hasError){
                    return Center(
                      child: Text('Bir hata oluştu, daha sonra tekrar deneyiniz.'),
                    );
                  } else {
                    var notList = asyncSnapshot.data??[];
                    return BuildNotListView(notList: notList);
                  }
                },
              ),
              Text('Yeni Not Ekle ....', style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(25, 45),maximumSize: const Size(70,70), primary: Colors.brown[200]),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotEkle()));
                }, 
                child: Image(image: AssetImage('assets/addnote.jpg', ),),)
                
              
            ],
          ),
        ),
      ),
    );
  }
}

class BuildNotListView extends StatefulWidget {
  final List<SeninNotlarin> notList;

  const BuildNotListView({ Key? key, required this.notList}) : super(key: key);

  @override
  _BuildNotListViewState createState() => _BuildNotListViewState();
}

class _BuildNotListViewState extends State<BuildNotListView> {
  @override
  Widget build(BuildContext context) {
    var fullNotList = widget.notList;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: fullNotList.length,
          itemBuilder: (context, index){
            return Slidable(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.brown[200],
                  child: GestureDetector(
                    onDoubleTap: () {
                    },
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: AssetImage('assets/note.jpg'),radius: 20,),
                      title: Text(fullNotList[index].not, style: TextStyle(fontSize: 15)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Text(Calculator.dateTimeToString(fullNotList[index].tarih.toDate()),
                    ),
                    ),
                  ),
                ),
                ),
              ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: (){},
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.black45,
                      onPressed: (_){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateSeninNotunView(
                              note: fullNotList[index],
                            )
                          )
                        );
                      },
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      backgroundColor: Colors.red,
                      onPressed: (_)async{
                        await Provider.of<SeninNotlarinViewModel>(context, listen: false).deleteNot(fullNotList[index]);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                    )
                  ],
                )
              );
          },
        ),
      ),
    );
  }
}
/*
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
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              child: Text('form deneme'),
            ),
          )
          ),
        ),
      );
    
  }
}*/