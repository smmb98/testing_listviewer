import 'dart:ui';
import 'stage_model.dart';

class SectionModel {
  final int id;
  final String title;
  final String? description;
  final Color color;
  final List<StageModel> stages;
  final List<StageModel> bonusStages;
  final bool isEnabled;
  final bool isCompleted;

  SectionModel({
    required this.id,
    required this.title,
    this.description,
    required this.color,
    required this.stages,
    this.bonusStages = const [],
    this.isEnabled = false,
    this.isCompleted = false,
  });

  SectionModel copyWith({
    int? id,
    String? title,
    String? description,
    Color? color,
    List<StageModel>? stages,
    List<StageModel>? bonusStages,
    bool? isEnabled,
    bool? isCompleted,
  }) {
    return SectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      stages: stages ?? this.stages,
      bonusStages: bonusStages ?? this.bonusStages,
      isEnabled: isEnabled ?? this.isEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': color.toARGB32(), // ✅ Safe, non-deprecated
      'stages': stages.map((stage) => stage.toJson()).toList(),
      'bonusStages': bonusStages.map((stage) => stage.toJson()).toList(),
      'isEnabled': isEnabled,
      'isCompleted': isCompleted,
    };
  }

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      color: Color(json['color'] as int),
      stages: (json['stages'] as List<dynamic>?)
              ?.map((e) => StageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bonusStages: (json['bonusStages'] as List<dynamic>?)
              ?.map((e) => StageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isEnabled: json['isEnabled'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
