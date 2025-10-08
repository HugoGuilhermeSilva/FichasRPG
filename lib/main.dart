import 'package:fichas/screens/atributes_screen.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:fichas/models/atributes.dart';
//import 'package:fichas/screens/atributes_screen.dart';
import 'package:fichas/common/attribute_box_widget.dart';
import 'package:fichas/common/expertise_box_widget.dart';
import 'package:fichas/common/advantages_widget.dart';
import 'package:fichas/screens/advantagens_screen.dart';
import 'package:fichas/common/power_box_widget.dart';
import 'package:fichas/screens/powers_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'teste',
      theme: ThemeData(primaryColor: Colors.white),
      home: const PowerScreen(),
    );
  }
}
