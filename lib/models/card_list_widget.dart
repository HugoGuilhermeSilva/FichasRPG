import 'package:flutter/material.dart';

class CardListWidget extends StatelessWidget{
  final bool? isTile;
  final String nameCard;
  const CardListWidget({required this.nameCard, super.key, this. isTile = false});

  @override
  Widget build(BuildContext context){
    return Card(
      color: isTile == false ? Colors.black : Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isTile == false ? Colors.purpleAccent : Colors.yellowAccent,
          width: 2
        ),
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(nameCard,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16
          ),),
        ),
      ),
    );
  }
}