import 'package:fichas/screens/record_screen.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/state_management/character_provider.dart';
import 'package:fichas/state_management/attributes_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CharacterProvider()),
        ChangeNotifierProvider(create: (context) => PowerProvider()),
        ChangeNotifierProxyProvider<CharacterProvider, AttributesProvider>(
          create: (context) => AttributesProvider(),
          update: (context, characterProvider, previousAttributesProvider) {
            if (previousAttributesProvider == null) {
            return AttributesProvider();
            }
            previousAttributesProvider.update(characterProvider);
            return previousAttributesProvider;
          },
        ),
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
      title: 'Fichas de RPG',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: const RecordScreen(),
    );
  }
}
