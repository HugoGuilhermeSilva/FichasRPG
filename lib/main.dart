import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fichas/models/atributes.dart';
import 'package:fichas/screens/atributes_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AttributeCalculator(divisor: 3), // exemplo
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
      home: Scaffold(
        appBar: AppBar(title: const Text("Sistema de Atributos")),
        body: const AttributeScreen(),
      ),
    );
  }
}