import 'package:testing_listviewer/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/progress_path_screen.dart';
import 'providers/study_data_provider.dart';
import 'repositories/shared_prefs_study_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final repository = SharedPrefsStudyRepository(prefs);

  runApp(ZigZagApp(repository: repository));
}

class ZigZagApp extends StatelessWidget {
  final SharedPrefsStudyRepository repository;

  const ZigZagApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StudyDataProvider(repository)..initialize(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProgressPathScreen(),
      ),
    );
  }
}
