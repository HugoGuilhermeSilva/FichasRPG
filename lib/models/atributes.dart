import 'package:flutter/cupertino.dart';

class AttributeCalculator extends ChangeNotifier{
  final int divisor;
  AttributeCalculator({required this.divisor});

  bool increaseEnabled = false;
  int baseAttribute = 0;
  int level = 0;
  final List<int> modifiers = [];

  int get attribute{
    if (increaseEnabled){
      return baseAttribute + _growthBonus() + _sumModifiers();
    }
    else{
      return baseAttribute + _sumModifiers();
    }
  }
  void setBaseAttribute(String value){
    baseAttribute = int.tryParse(value) ?? 0 ;
    notifyListeners();
  }
  void setLevel(String value){
    level = int.tryParse(value) ?? 0 ;
    notifyListeners();
  }
  void addModifier(int value){
    modifiers.add(value);
    notifyListeners();
  }
  void removeModifier(int value){
    modifiers.remove(value);
    notifyListeners();
  }
  int _growthBonus() => (level / divisor).ceil() + 2;
  int _sumModifiers() => modifiers.fold(0, (sum, m) => sum + m);
}