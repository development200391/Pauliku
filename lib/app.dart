import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/home/home_screen.dart';

class PauliApp extends StatelessWidget {
  const PauliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PauliKu',
      debugShowCheckedModeBanner: false,
      theme: buildPauliTheme(),
      home: const HomeScreen(),
    );
  }
}
