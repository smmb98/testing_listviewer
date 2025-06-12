import 'package:testing_listviewer/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/zigzag_screen.dart';
import 'providers/button_state_provider.dart';

void main() => runApp(const ZigZagApp());

class ZigZagApp extends StatelessWidget {
  const ZigZagApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ButtonStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ZigZagScreen(),
      ),
    );
  }
}
