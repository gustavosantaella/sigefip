import 'package:flutter/material.dart';
import 'package:sigefip/modules/home/home_screen.dart';
import 'package:sigefip/core/constants/theme.dart' as constants;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGEFIP',
      theme: constants.Theme.getTheme(),
      routes: {'/': (context) => const HomeScreen()},
    );
  }
}
