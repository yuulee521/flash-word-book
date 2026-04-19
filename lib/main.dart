import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/word_provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wordProvider = WordProvider();

  try {
    await wordProvider.initDb();
  } catch (e) {
    debugPrint('Failed to initialize database: $e');
    wordProvider.setError('Failed to initialize database: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => wordProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flash Word Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
