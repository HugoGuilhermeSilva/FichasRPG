import 'package:flutter/material.dart';

class ExpertiseFields extends StatelessWidget{
  final String name;
  final TextEditingController bonus;
  final TextEditingController total;

  const ExpertiseFields({
    required this.name,
    required this.bonus,
    required this.total,
    super.key
});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 210,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: Text(name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
        ),
        Spacer(),
        SizedBox(
          width: 90,
          child: TextField(
            textAlign: TextAlign.center,
            controller: bonus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'Bonus',
              labelStyle: const TextStyle(color: Colors.deepPurple),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 8,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: total,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
    ] );
  }
}