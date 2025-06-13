import 'package:flutter/material.dart';
import '../models/study/study_data_model.dart';
import '../models/study/section_model.dart';
import '../models/study/stage_model.dart';
import '../repositories/study_repository.dart';

class StudyService extends ChangeNotifier {
  final StudyRepository _repository;
  late StudyDataModel _studyData;
  bool _isLoading = false;

  StudyService(this._repository) {
    _loadStudyData();
  }

  bool get isLoading => _isLoading;
  StudyDataModel get studyData => _studyData;

  Future<void> _loadStudyData() async {
    _isLoading = true;
    notifyListeners();

    _studyData = await _repository.loadStudyData();

    // If this is the first time loading, initialize the first stage
    if (_studyData.sections.isEmpty) {
      _studyData = _initializeFirstSection();
      await _repository.saveStudyData(_studyData);
    }

    _isLoading = false;
    notifyListeners();
  }

  StudyDataModel _initializeFirstSection() {
    final firstStage = StageModel(
      id: 1,
      sectionId: 1,
      title: 'First Stage',
      isEnabled: true,
    );

    final firstSection = SectionModel(
      id: 1,
      title: 'First Section',
      stages: [firstStage],
      isEnabled: true,
      color: Colors.red,
    );

    return StudyDataModel(sections: [firstSection]);
  }

  Future<void> completeStage(int sectionId, int stageId) async {
    final sectionIndex =
        _studyData.sections.indexWhere((s) => s.id == sectionId);
    if (sectionIndex == -1) return;

    final section = _studyData.sections[sectionIndex];
    final stageIndex = section.stages.indexWhere((s) => s.id == stageId);
    if (stageIndex == -1) return;

    // Update the completed stage
    final updatedStages = List<StageModel>.from(section.stages);
    updatedStages[stageIndex] = updatedStages[stageIndex].copyWith(
      isCompleted: true,
    );

    // Enable the next stage or section
    if (stageIndex < updatedStages.length - 1) {
      // Enable next stage in current section
      updatedStages[stageIndex + 1] = updatedStages[stageIndex + 1].copyWith(
        isEnabled: true,
      );
    } else if (sectionIndex < _studyData.sections.length - 1) {
      // Enable first stage of next section
      final nextSection = _studyData.sections[sectionIndex + 1];
      final updatedNextSection = nextSection.copyWith(
        isEnabled: true,
        stages: [
          nextSection.stages[0].copyWith(isEnabled: true),
          ...nextSection.stages.sublist(1),
        ],
      );

      // Update sections list
      final updatedSections = List<SectionModel>.from(_studyData.sections);
      updatedSections[sectionIndex + 1] = updatedNextSection;
      _studyData = _studyData.copyWith(sections: updatedSections);
    }

    // Update current section
    final updatedSection = section.copyWith(
      stages: updatedStages,
      isCompleted: updatedStages.every((stage) => stage.isCompleted),
    );

    // Update sections list
    final updatedSections = List<SectionModel>.from(_studyData.sections);
    updatedSections[sectionIndex] = updatedSection;
    _studyData = _studyData.copyWith(sections: updatedSections);

    // Save changes
    await _repository.saveStudyData(_studyData);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _studyData = _initializeFirstSection();
    await _repository.saveStudyData(_studyData);
    notifyListeners();
  }
}
