import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final String? title;
  const CheckboxWidget ({Key? key, this.title}) : super(key: key);

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool? value = false;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: this.value,

          onChanged: (bool? value) {
            setState(() {
              this.value = value;

            });
          },
        ),
        checkBoxDecider(value),
        Align(
            alignment: Alignment.centerRight,
            child: IconButton(icon:Icon(Icons.delete),color: Colors.red,onPressed: (){
              print("deleted todo");
            },))
      ],
    );
  }

  Text checkBoxDecider(bool? value) {
    String title2 = widget.title.toString();

    if(value == true) {
      return Text(title2,overflow: TextOverflow.ellipsis,maxLines: 3,style: TextStyle(decoration: TextDecoration.lineThrough,color:Colors.white,fontSize: 10,fontWeight: FontWeight.w200),textAlign: TextAlign.start,);
    }else {
      return Text(title2,overflow: TextOverflow.ellipsis,maxLines: 3,style: TextStyle(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w200),textAlign: TextAlign.start,);
    }
  }


}
