import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testing_listviewer/widgets/section_header_delegate.dart';
import 'package:testing_listviewer/widgets/shimmer_widget.dart';
import '../providers/study_data_provider.dart';
import '../widgets/section_widget.dart';
import '../widgets/section_header.dart';
import '../utils/responsive.dart';
import '../widgets/back_to_top.dart';
import '../widgets/settings_menu.dart';

class ProgressPathScreen extends StatefulWidget {
  const ProgressPathScreen({super.key});

  @override
  State<ProgressPathScreen> createState() => _ProgressPathScreenState();
}

class _ProgressPathScreenState extends State<ProgressPathScreen> {
  final ScrollController controller = ScrollController();
  bool showBackToTop = false;
  int? _currentPinnedIndex;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (controller.offset > 200 && !showBackToTop) {
      setState(() {
        showBackToTop = true;
      });
    } else if (controller.offset <= 200 && showBackToTop) {
      setState(() {
        showBackToTop = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = SizeConfig.hp(
      SizeConfig.isLandscape(context) ? 20 : 10,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Study Sections',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const SettingsMenu(),
      body: Consumer<StudyDataProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const ShimmerSectionWidget(
              sectionIndex: 0,
            );
          }

          return CustomScrollView(
            controller: controller,
            slivers: [
              ...provider.sections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;

                return SliverMainAxisGroup(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SectionHeaderDelegate(
                        sectionIndex: index,
                        minHeight: headerHeight,
                        maxHeight: headerHeight,
                        child: SectionHeader(
                          section: section,
                          isLandscape: SizeConfig.isLandscape(context),
                        ),
                        onPinned: () {
                          if (_currentPinnedIndex == index) return;
                          _currentPinnedIndex = index;
                          HapticFeedback.heavyImpact();
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SectionWidget(
                        section: section,
                        sectionIndex: index,
                      ),
                    ),
                  ],
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: showBackToTop
          ? BackToTopButton(
              onPressed: () {
                controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            )
          : null,
    );
  }
}
