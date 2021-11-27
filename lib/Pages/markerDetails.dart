import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:texple_test/StateManagement/providerstate.dart';

class MarkerDetail extends StatefulWidget {
  const MarkerDetail({Key? key}) : super(key: key);

  @override
  _MarkerDetailState createState() => _MarkerDetailState();
}

class _MarkerDetailState extends State<MarkerDetail> {
  @override

  late TextEditingController titleController,labelController;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  var formKey = GlobalKey<FormState>();

  late int redv,greenv,bluev;

  bool showColorPicker = false;

  bool ColorSelected = false;
  bool showDialogBox = false;


  initState()
  {
    super.initState();
    titleController = new TextEditingController();
    labelController = new TextEditingController();
    redv = 100;
    greenv = 100;
    bluev=100;
  }


  void changeColor(Color color) {

      pickerColor = color;
      redv = pickerColor.red;
      greenv = pickerColor.green;
      bluev = pickerColor.blue;


  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Consumer<MarkerNotifier>(builder:(context,notifier,child){
          return Form(key: formKey,
            child: Container(child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Please enter marker details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  Expanded(child: Text("Title")),
                  Expanded(flex: 3,
                      child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: (value){
                          if(value!.length<3)
                            {
                              return "Title should be more than 2 characters";
                            }
                        },
                          controller: titleController,decoration: InputDecoration(enabledBorder: InputBorder.none,

                        ),),
                      )),
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  Expanded(
                      child: Text("Label")),
                  Expanded(flex: 3,
                      child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(  validator: (value){
                            if(value!.length<3)
                            {
                              return "Label should be more than 2 characters";
                            }
                          },
                            controller: labelController,decoration: InputDecoration(enabledBorder: InputBorder.none,),))),
                ],),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(onTap: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return  AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                            ),

                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                print("redv $redv");
                                setState(() {
                                  currentColor = pickerColor;
                                  ColorSelected = true;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(decoration: BoxDecoration(color: Colors.yellow[100],borderRadius: BorderRadius.circular(10)),

                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Pick Marker Colour",style: TextStyle(color: Colors.blue,fontSize: 15),),
                            ))),
                      )),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(onTap: (){
                    if(formKey.currentState!.validate())
                      {
                        if(ColorSelected == true)
                          {
                            Provider.of<MarkerNotifier>(context, listen: false).addMarker(titleController.text, labelController.text, redv, greenv, bluev);
                            Navigator.pop(context);
                          }
                        else
                          {
                            showDialog(context: context, builder: (context){
                              return AlertDialog(title: Text("Please select a colour"),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text("Ok"))
                              ],);
                            });
                          }

                      }
                    else
                      {
                        return;
                      }


                  },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(decoration: BoxDecoration(color: Colors.yellow,borderRadius: BorderRadius.circular(10)),

                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Add Marker",style: TextStyle(color: Colors.blue,fontSize: 15),),
                            ))),
                      )),


                ],
              ),

            ],),),
          );
    }


      )
    ));
  }
}
