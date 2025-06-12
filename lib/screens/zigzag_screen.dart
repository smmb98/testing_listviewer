import 'package:testing_listviewer/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import '../providers/section_loader.dart';
import '../widgets/section_widget.dart';
import '../utils/responsive.dart';
import '../widgets/section_header.dart';
import '../widgets/section_header_delegate.dart';

class ZigZagScreen extends StatefulWidget {
  const ZigZagScreen({super.key});

  @override
  State<ZigZagScreen> createState() => _ZigZagScreenState();
}

class _ZigZagScreenState extends State<ZigZagScreen> {
  final SectionLoader loader = SectionLoader();
  final ScrollController controller = ScrollController();
  bool showBackToTop = false;

  @override
  void initState() {
    super.initState();
    loader.loadInitialSections();
    controller.addListener(_onScroll);
  }

  void _onScroll() {
    // Show back-to-top button logic
    final shouldShow = controller.offset > MediaQuery.of(context).size.height;
    if (shouldShow != showBackToTop) {
      setState(() => showBackToTop = shouldShow);
    }

    // Lazy loading logic
    if (controller.position.pixels >=
            controller.position.maxScrollExtent - 800 &&
        !loader.isLoading) {
      loader.loadMoreSections();
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
      // appBar: AppBar(title: const Text("Zig-Zag Viewer")),
      floatingActionButton: showBackToTop
          ? FloatingActionButton(
              onPressed: () {
                controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      body: AnimatedBuilder(
        animation: loader,
        builder: (context, _) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              ...loader.sections.asMap().entries.map((entry) {
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
              if (loader.hasMore)
                SliverToBoxAdapter(
                  child: ShimmerSectionWidget(
                    sectionIndex: loader.sections.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
