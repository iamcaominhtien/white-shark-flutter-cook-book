import 'package:cookbook/main.dart';
import 'package:flutter/material.dart';

import 'load_excel.dart';

class ExcelHome extends StatelessWidget {
  const ExcelHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Excel home')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildButtonNavigator(context, 'load excel', const LoadExcel()),
        ],
      ),
    );
  }
}
