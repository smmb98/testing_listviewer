class StageModel {
  final int id;
  final int sectionId;
  final String title;
  final String? description;
  final bool isEnabled;
  final bool isCompleted;

  StageModel({
    required this.id,
    required this.sectionId,
    required this.title,
    this.description,
    this.isEnabled = false,
    this.isCompleted = false,
  });

  StageModel copyWith({
    int? id,
    int? sectionId,
    String? title,
    String? description,
    bool? isEnabled,
    bool? isCompleted,
  }) {
    return StageModel(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      title: title ?? this.title,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'title': title,
      'description': description,
      'isEnabled': isEnabled,
      'isCompleted': isCompleted,
    };
  }

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'] as int,
      sectionId: json['sectionId'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
