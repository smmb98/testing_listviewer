import 'package:flutter/material.dart';
import '../models/button_state.dart';

class ButtonStateProvider extends ChangeNotifier {
  final Map<String, ButtonState> _buttonStates = {};
  final Map<int, int> _sectionButtonCounts = {};

  ButtonStateProvider() {
    // Initialize first button of first section as enabled
    _buttonStates[_getKey(0, 0)] = ButtonState(
      sectionIndex: 0,
      buttonIndex: 0,
      isEnabled: true,
    );
  }

  String _getKey(int sectionIndex, int buttonIndex) {
    return '$sectionIndex:$buttonIndex';
  }

  ButtonState? getButtonState(int sectionIndex, int buttonIndex) {
    return _buttonStates[_getKey(sectionIndex, buttonIndex)];
  }

  void setSectionButtonCount(int sectionIndex, int buttonCount) {
    _sectionButtonCounts[sectionIndex] = buttonCount;
  }

  void completeButton(int sectionIndex, int buttonIndex) {
    final currentState = getButtonState(sectionIndex, buttonIndex);
    if (currentState == null || !currentState.isEnabled) return;

    // Mark current button as completed
    _buttonStates[_getKey(sectionIndex, buttonIndex)] = currentState.copyWith(
      isCompleted: true,
    );

    // Get the number of buttons in the current section
    final currentSectionButtonCount = _sectionButtonCounts[sectionIndex] ?? 0;

    // Enable next button
    final nextButtonIndex = buttonIndex + 1;

    // If we're at the end of a section, enable first button of next section
    if (nextButtonIndex >= currentSectionButtonCount) {
      _buttonStates[_getKey(sectionIndex + 1, 0)] = ButtonState(
        sectionIndex: sectionIndex + 1,
        buttonIndex: 0,
        isEnabled: true,
      );
    } else {
      _buttonStates[_getKey(sectionIndex, nextButtonIndex)] = ButtonState(
        sectionIndex: sectionIndex,
        buttonIndex: nextButtonIndex,
        isEnabled: true,
      );
    }

    notifyListeners();
  }

  bool isButtonEnabled(int sectionIndex, int buttonIndex) {
    final state = getButtonState(sectionIndex, buttonIndex);
    return state?.isEnabled ?? false;
  }

  bool isButtonCompleted(int sectionIndex, int buttonIndex) {
    final state = getButtonState(sectionIndex, buttonIndex);
    return state?.isCompleted ?? false;
  }
}
