import 'dart:math';
import 'package:flutter/material.dart';
import '../models/section_model.dart';

class SectionLoader extends ChangeNotifier {
  final List<SectionModel> _sections = [];
  bool isLoading = false;
  bool hasMore = true;
  int loadedSections = 0;
  final int sectionLimit; // Set to null for infinite

  SectionLoader({this.sectionLimit = 0});

  List<SectionModel> get sections => _sections;

  void loadInitialSections() => _loadMoreInternal();

  void loadMoreSections() {
    if (!isLoading) _loadMoreInternal();
  }

  void _loadMoreInternal() async {
    if (sectionLimit > 0 && loadedSections >= sectionLimit) {
      hasMore = false;
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulated delay

    final rand = Random();
    for (int i = 0; i < 10; i++) {
      _sections.add(
        SectionModel(
          title: "Section ${loadedSections + 1}",
          color: Colors.primaries[loadedSections % Colors.primaries.length],
          buttonCount: rand.nextInt(18) + 2,
        ),
      );
      loadedSections++;
    }

    isLoading = false;
    notifyListeners();
  }
}
