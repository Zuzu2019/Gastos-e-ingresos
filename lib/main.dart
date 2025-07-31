import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart'; // Asegúrate de que este archivo exista

void main() {
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  runApp(ProviderScope(child: MyApp())); // ProviderScope viene de Riverpod
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de gastos e ingresos',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
