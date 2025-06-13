import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_listviewer/widgets/section_header_delegate.dart';
import '../providers/study_data_provider.dart';
import '../widgets/section_widget.dart';
import '../widgets/section_header.dart';
import '../utils/responsive.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/back_to_top.dart';

class ZigZagScreen extends StatefulWidget {
  const ZigZagScreen({super.key});

  @override
  State<ZigZagScreen> createState() => _ZigZagScreenState();
}

class _ZigZagScreenState extends State<ZigZagScreen> {
  // final SectionLoader loader = SectionLoader();
  final ScrollController controller = ScrollController();
  bool showBackToTop = false;
  // DateTime? _lastLoadTime;

  @override
  void initState() {
    super.initState();
    // loader.loadInitialSections();
    controller.addListener(_onScroll);
  }

  void _onScroll() {
    //final screenHeight = MediaQuery.of(context).size.height;

    // // Back-to-top button logic
    // final shouldShow = controller.offset > screenHeight;
    // if (shouldShow != showBackToTop) {
    //   setState(() => showBackToTop = shouldShow);
    if (controller.offset > 200 && !showBackToTop) {
      setState(() {
        showBackToTop = true;
      });
    } else if (controller.offset <= 200 && showBackToTop) {
      setState(() {
        showBackToTop = false;
      });
    }

    // // Lazy loading logic using dynamic buffer (5x screen height from bottom)
    // final preloadOffset = 4 * screenHeight;
    // final currentOffset = controller.position.pixels;
    // final maxOffset = controller.position.maxScrollExtent;

    // // Add debounce check
    // final now = DateTime.now();
    // if (_lastLoadTime != null &&
    //     now.difference(_lastLoadTime!).inMilliseconds < 2000) {
    //   return;
    // }

    // if (currentOffset >= maxOffset - preloadOffset && !loader.isLoading) {
    //   _lastLoadTime = now;
    //   // loader.loadMoreSections();
    // }
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
      body: Consumer<StudyDataProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const ShimmerLoading();
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
                        minHeight: headerHeight,
                        maxHeight: headerHeight,
                        child: SectionHeader(
                          section: section,
                          isLandscape: SizeConfig.isLandscape(context),
                        ),
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
              }).toList(),
              // if (provider.hasMore)
              //   SliverToBoxAdapter(
              //     child: ShimmerSectionWidget(
              //       sectionIndex: provider.sections.length,
              //     ),
              //   ),
            ],
          );
        },
      ),
//
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
