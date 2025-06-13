import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/study/study_data_model.dart';
import 'study_repository.dart';

class SharedPrefsStudyRepository implements StudyRepository {
  static const String _studyDataKey = 'study_data';
  final SharedPreferences _prefs;

  SharedPrefsStudyRepository(this._prefs);

  @override
  Future<StudyDataModel> loadStudyData() async {
    final jsonString = _prefs.getString(_studyDataKey);
    if (jsonString == null) {
      return StudyDataModel.initial();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return StudyDataModel.fromJson(json);
    } catch (e) {
      // If there's an error loading the data, return initial state
      return StudyDataModel.initial();
    }
  }

  @override
  Future<void> saveStudyData(StudyDataModel data) async {
    final jsonString = jsonEncode(data.toJson());
    await _prefs.setString(_studyDataKey, jsonString);
  }

  @override
  Future<void> clearStudyData() async {
    await _prefs.remove(_studyDataKey);
  }
}
