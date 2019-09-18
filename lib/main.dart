import 'package:converter_app/category_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.grey[600],
              ),
          primaryColor: Colors.grey[500],
          textSelectionHandleColor: Colors.green[500]),
      home: CategoryRoute(),
    );
  }
}
