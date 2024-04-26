import 'package:clean_architecture_demo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture Demo',
      theme: appTheme ,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clean Architecture Demo'),
        ),
        body: Center(
          child: Text(
            'Clean Architecture',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
