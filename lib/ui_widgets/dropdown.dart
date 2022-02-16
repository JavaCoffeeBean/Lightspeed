import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  const Dropdown ({Key? key}) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? selectedValue = "ID";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(iconEnabledColor: Colors.green,
      style: TextStyle(color: Colors.white,fontSize: 10,fontWeight:FontWeight.w200 ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.withOpacity(.5), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: Colors.green.withOpacity(.5),
        ),
        dropdownColor: Colors.green.withOpacity(.5),
        value: selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
        items: dropdownItems);
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("ID"),value: "ID"),
      DropdownMenuItem(child: Text("A-Z"),value: "A-Z"),
    ];
    return menuItems;
  }
}
