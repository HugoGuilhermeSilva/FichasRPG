import 'package:flutter/material.dart';

class PassivesShowCard extends StatelessWidget{
  final String title;
  final String description;
  const PassivesShowCard({required this.title, required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 450,
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.purpleAccent,
                width: 2
            ),
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                child: Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 22),),
              ),
              SizedBox(height: 8,),
              Expanded(child: SingleChildScrollView(child: Text(description,style: TextStyle(color: Colors.white, fontSize: 16))))
            ],
          ),
        ),
      ),
    );
  }
}