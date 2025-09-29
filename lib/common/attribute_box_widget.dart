
//import 'package:fichas/models/atributes.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class AttributeField extends StatelessWidget{
  final String label;
  const AttributeField({super.key, required this.label});

  @override
  Widget build(BuildContext context){

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            decoration: const InputDecoration(hintText: 'Base'),
            keyboardType: TextInputType.number,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 30,
          child: Text(
            '0',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Checkbox(
          value: false,
          onChanged: (_){},
        ),
      ],
    );
  }
}
class AttributeBox extends StatelessWidget{
  const AttributeBox({super.key});
  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                RichText(text: TextSpan(
                    text: 'Atributos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
                SizedBox(width: 73,),
                SizedBox(height: 16,),
                RichText(text: TextSpan(
                    text: 'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
                SizedBox(width: 14),
                SizedBox(height: 16,),
                RichText(text: TextSpan(
                    text: '+',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                )),
              ]
          ),
          SizedBox(height: 4),
          SizedBox(height: 16),
          AttributeField(label: 'Força'),
          AttributeField(label: 'Destreza'),
          AttributeField(label: 'Agilidade'),
          AttributeField(label: 'Vigor'),
          AttributeField(label: 'Percepção'),
          AttributeField(label: 'Inteligencia'),
          AttributeField(label: 'Vontade'),
          AttributeField(label: 'Carisma')
        ],
      ),
    );

  }
}