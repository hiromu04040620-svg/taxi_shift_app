import 'package:flutter/material.dart';

class TaxiShiftApp extends StatelessWidget {
  const TaxiShiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaxiShift',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('Hello, TaxiShift'))),
    );
  }
}
