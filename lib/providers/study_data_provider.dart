import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study/study_data_model.dart';
import '../models/study/section_model.dart';
import '../models/study/stage_model.dart';
import '../repositories/study_repository.dart';

class StudyDataProvider extends ChangeNotifier {
  final StudyRepository _repository;
  StudyDataModel? _studyData;
  bool _isLoading = false;
  final Map<int, int> _sectionStageCounts = {};

  StudyDataProvider(this._repository);

  // Getters
  StudyDataModel? get studyData => _studyData;
  bool get isLoading => _isLoading;
  List<SectionModel> get sections => _studyData?.sections ?? [];

  // Set section stage count
  void setSectionStageCount(int sectionIndex, int stageCount) {
    _sectionStageCounts[sectionIndex] = stageCount;
  }

  // Initialize data on app start
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to load persisted data
      _studyData = await _repository.loadStudyData();

      // If no data exists, initialize with default sections
      if (_studyData == null || _studyData!.sections.isEmpty) {
        _studyData = _initializeDefaultSections();
        // Save the initial data
        await _repository.saveStudyData(_studyData!);
      }
    } catch (e) {
      // If there's an error loading data, initialize with defaults
      _studyData = _initializeDefaultSections();
      await _repository.saveStudyData(_studyData!);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Initialize default sections with stages
  StudyDataModel _initializeDefaultSections() {
    final sections = List.generate(
      3,
      (sectionIndex) {
        final stages = List.generate(
          5,
          (stageIndex) => StageModel(
            id: stageIndex + 1,
            sectionId: sectionIndex + 1,
            title: 'Stage ${stageIndex + 1}',
            isEnabled: stageIndex == 0 && sectionIndex == 0,
          ),
        );

        return SectionModel(
          id: sectionIndex + 1,
          title: 'Section ${sectionIndex + 1}',
          color: Colors.primaries[sectionIndex % Colors.primaries.length],
          stages: stages,
          isEnabled: sectionIndex == 0,
        );
      },
    );

    return StudyDataModel(sections: sections);
  }

  // Complete a stage and update both provider and persistence
  Future<void> completeStage(int sectionId, int stageId) async {
    if (_studyData == null) return;

    final sectionIndex =
        _studyData!.sections.indexWhere((s) => s.id == sectionId);
    if (sectionIndex == -1) return;

    final section = _studyData!.sections[sectionIndex];
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
    } else if (sectionIndex < _studyData!.sections.length - 1) {
      // Enable first stage of next section
      final nextSection = _studyData!.sections[sectionIndex + 1];
      final updatedNextSection = nextSection.copyWith(
        isEnabled: true,
        stages: [
          nextSection.stages[0].copyWith(isEnabled: true),
          ...nextSection.stages.sublist(1),
        ],
      );

      // Update sections list
      final updatedSections = List<SectionModel>.from(_studyData!.sections);
      updatedSections[sectionIndex + 1] = updatedNextSection;
      _studyData = _studyData!.copyWith(sections: updatedSections);
    }

    // Update current section
    final updatedSection = section.copyWith(
      stages: updatedStages,
      isCompleted: updatedStages.every((stage) => stage.isCompleted),
    );

    // Update sections list
    final updatedSections = List<SectionModel>.from(_studyData!.sections);
    updatedSections[sectionIndex] = updatedSection;
    _studyData = _studyData!.copyWith(sections: updatedSections);

    // Save changes to persistence
    await _repository.saveStudyData(_studyData!);
    notifyListeners();
  }

  // Reset progress to initial state
  Future<void> resetProgress() async {
    _studyData = _initializeDefaultSections();
    await _repository.saveStudyData(_studyData!);
    notifyListeners();
  }
}
