
import 'package:flutter/material.dart';

class ExpertiseField extends StatelessWidget{
  final String label;
  const ExpertiseField({required this.label, super.key});

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        const SizedBox(width: 8,),
        SizedBox(
          width: 60,
          child: TextField(
            decoration: InputDecoration(hintText: 'Bônus'),
            keyboardType: TextInputType.number,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )
        ),
        const SizedBox(width: 16,),
        SizedBox(
          width: 30,
          child: Text('0',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        const SizedBox(width: 8,),
        Checkbox(value: false, onChanged: (_){}),
      ],
    );
  }
}
class ExpertiseBox extends StatelessWidget{
  const ExpertiseBox({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children:[
            RichText(text: TextSpan(
              text: 'Pericias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
            ))),
            SizedBox(width: 115,),
            SizedBox(height: 16,),
            RichText(text: TextSpan(
                text: 'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ))),
            SizedBox(width: 15),
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

          SizedBox(height: 6,),
          SizedBox(height: 16,),
          ExpertiseField(label: 'Acrobacia'),
          ExpertiseField(label: 'Atletismo'),
          ExpertiseField(label: 'Blefe'),
          ExpertiseField(label: 'Ciência'),
          ExpertiseField(label: 'Conhecimento'),
          ExpertiseField(label: 'Concentração'),
          ExpertiseField(label: 'Cultura'),
          ExpertiseField(label: 'Disfarce'),
          ExpertiseField(label: 'Furtividade'),
          ExpertiseField(label: 'Intimidação'),
          ExpertiseField(label: 'Intuição'),
          ExpertiseField(label: 'Investigação'),
          ExpertiseField(label: 'Lidar com Animais'),
          ExpertiseField(label: 'Performace'),
          ExpertiseField(label: 'Persuasão'),
          ExpertiseField(label: 'Prestidigitação'),
          ExpertiseField(label: 'Prontidão'),
          ExpertiseField(label: 'Procurar'),
          ExpertiseField(label: 'Rastrear'),
        ],
      ),
    );
  }
}