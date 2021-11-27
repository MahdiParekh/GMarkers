import 'package:flutter/material.dart';
import 'package:texple_test/tempdata.dart';


class LabelComp extends StatefulWidget {
  @override

  String title;


  LabelComp({required this.title});

  _LabelCompState createState() => _LabelCompState();
}

class _LabelCompState extends State<LabelComp> {
  @override
  bool checkedOrNot=false;

  


  void initState()
  {

    if(checkedLabels.contains(widget.title))
    {
      checkedOrNot = true;

    }
    else
    {
      checkedOrNot=false;

    }

  }



  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.title) ,value: checkedOrNot, onChanged: (value){

      setState(() {
        checkedOrNot = value!;

        if(checkedOrNot==true)
        {
          print("in if");
         checkedLabels.add(widget.title);
         
        }
        else
    {

    checkedLabels.remove(widget.title);
    }
    });
  });
}}