import '../models/study/study_data_model.dart';

abstract class StudyRepository {
  Future<StudyDataModel> loadStudyData();
  Future<void> saveStudyData(StudyDataModel data);
  Future<void> clearStudyData();
}
