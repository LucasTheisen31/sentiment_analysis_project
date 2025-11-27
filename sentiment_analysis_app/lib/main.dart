import 'package:sentiment_analysis_app/core/env/env.dart';
import 'package:sentiment_analysis_app/core/ui/theme/theme_config.dart';
import 'package:sentiment_analysis_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classificador de Comentários',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.defaultTheme,
      home: const HomeScreen(),
    );
  }
}
