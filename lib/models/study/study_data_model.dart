import 'section_model.dart';

class StudyDataModel {
  final List<SectionModel> sections;
  final DateTime lastUpdated;

  StudyDataModel({
    required this.sections,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  StudyDataModel copyWith({
    List<SectionModel>? sections,
    DateTime? lastUpdated,
  }) {
    return StudyDataModel(
      sections: sections ?? this.sections,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sections': sections.map((section) => section.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory StudyDataModel.fromJson(Map<String, dynamic> json) {
    return StudyDataModel(
      sections: (json['sections'] as List)
          .map((section) =>
              SectionModel.fromJson(section as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  factory StudyDataModel.initial() {
    return StudyDataModel(
      sections: [],
      lastUpdated: DateTime.now(),
    );
  }
}
