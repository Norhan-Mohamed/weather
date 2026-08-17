import 'package:flutter/material.dart';
import 'package:weatherapp/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff4480c6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
