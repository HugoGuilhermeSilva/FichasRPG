import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

class PowerCards extends StatelessWidget{
  final String name;
  final String description;
  final bool selected;
  final int cost;
  final ValueChanged<bool?> onChanged;

  const PowerCards({
    required this.name,
    required this.description,
    required this.cost,
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
            ),
            child: Row(
              children: [
                Expanded(child: Center(
                  child: Text(name,style: TextStyle(color: Colors.white, fontSize: 22),),
                )),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.deepPurple),
                    color: Colors.black
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: SpinBox(
                          min: 0,
                          max: 500,
                          step: 1,
                          decimals: 0,
                          showButtons: true,
                          textStyle: TextStyle(color: Colors.white, fontSize: 16,),
                          iconColor: WidgetStateProperty.all(Colors.purpleAccent),
                          iconSize: 16,
                          spacing: 0,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.black,
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        ),
                        ),
                      ),
                      Tooltip(
                        message: 'Graus comprados',
                        child: IconButton(onPressed: (){}, icon: Icon(Icons.info, color: Colors.deepPurple,)),
                      ),
                    ],
                  )
                ),
                Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.deepPurple),
                color: Colors.black
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 4.5,),
                      Text(cost.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                      Tooltip(
                        message: 'Custo',
                        child: IconButton(onPressed: (){}, icon: Icon(Icons.info, color: Colors.deepPurple,)),
                      ),
                    ],
                  ),
                ),
                Checkbox(value: selected, onChanged: onChanged),
              ],
            ),
          ),
          ConstrainedBox(constraints: BoxConstraints(
            maxWidth: 400,
          ),
            child: Text(description, style: TextStyle(color: Colors.white, fontSize: 18),),
          )
        ],
      ),
    );
  }
}
class Powers{
  final String name;
  final String description;
  final int cost;
  bool selected;
  Powers({
    required this.name,
    required this.description,
    required this.cost,
    this.selected = false,
});
}