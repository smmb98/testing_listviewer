import 'package:testing_listviewer/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'screens/zigzag_screen.dart';

void main() => runApp(const ZigZagApp());

class ZigZagApp extends StatelessWidget {
  const ZigZagApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ZigZagScreen(),
    );
  }
}
