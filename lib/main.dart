import 'package:flutter/material.dart';
import 'device_model.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/humidifier_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/humidifier': (context) {
          final device = ModalRoute.of(context)!.settings.arguments as Device;
          return HumidifierScreen(device: device);
        },
      },
    );
  }
}