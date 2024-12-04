import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart'; 
import 'task_notifier.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task Manager'),
      debugShowCheckedModeBanner: false,
    );
  }
}
