import 'package:fichas/state_management/character_provider.dart';
import 'package:flutter/material.dart';

class SpellsProvider with ChangeNotifier{
  final CharacterProvider characterProvider;
  SpellsProvider({required this.characterProvider});
  
}