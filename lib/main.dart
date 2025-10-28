import 'package:fichas/screens/record_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/screens/archetype_screen.dart';
import 'package:fichas/state_management/attributes_provider.dart';
import 'package:fichas/state_management/character_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CharacterProvider()),
        ChangeNotifierProxyProvider<CharacterProvider, AttributesProvider>(
          create: (context) => AttributesProvider(),
          update: (context, characterProvider, previousAttributesProvider){
            final attributesProvider = previousAttributesProvider!;
            attributesProvider.update(characterProvider);
            return attributesProvider;
          },
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fichas RPG',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const RecordScreen(),
    );
  }
}

