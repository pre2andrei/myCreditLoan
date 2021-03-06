import 'package:flutter/material.dart';

import 'screens/LoanDataScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Credit Loan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoanDataScreen(title: 'My Credit Loan'),
    );
  }
}
