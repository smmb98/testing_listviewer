class ButtonState {
  final int sectionIndex;
  final int buttonIndex;
  final bool isEnabled;
  final bool isCompleted;

  ButtonState({
    required this.sectionIndex,
    required this.buttonIndex,
    this.isEnabled = false,
    this.isCompleted = false,
  });

  ButtonState copyWith({
    int? sectionIndex,
    int? buttonIndex,
    bool? isEnabled,
    bool? isCompleted,
  }) {
    return ButtonState(
      sectionIndex: sectionIndex ?? this.sectionIndex,
      buttonIndex: buttonIndex ?? this.buttonIndex,
      isEnabled: isEnabled ?? this.isEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
