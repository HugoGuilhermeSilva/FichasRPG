import 'package:flutter/material.dart';

class AdvantagesCards extends StatelessWidget {
  final String name;
  final String description;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  const AdvantagesCards({
    required this.name,
    required this.description,
    required this.selected,
    required this.onChanged,
    super.key
  });
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(4),
          color: Colors.black
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstrainedBox(constraints: BoxConstraints(
            maxWidth: 350
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Center(
                  child: Text(name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )),
                Checkbox(value: selected, onChanged: onChanged),
              ],
            ),
          ),
          SizedBox(height: 8,),
         ConstrainedBox(constraints: BoxConstraints(
           maxWidth: 350
         ),
           child:  Text(description,
             style: TextStyle(
                 color: Colors.white,
                 fontSize: 18
             ),
           ),
         )
        ],
      ),
    );
  }
}
class Advantage{
  String name;
  String description;
  bool selected;
  Advantage({
    required this.name,
    required this.description,
    this.selected = false
});
}