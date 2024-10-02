// Archivo: main.dart
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Asegúrate de que este archivo exista y esté en la misma carpeta

void main() {
  runApp(HotelApp());
}

class HotelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel PWA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
