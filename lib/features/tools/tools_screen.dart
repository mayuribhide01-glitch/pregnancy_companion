import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/photo_card.dart';
import '../../core/widgets/section_header.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../shell/main_shell.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  void _open(BuildContext context, ToolItem tool) {
    switch (tool.route) {
      case Routes.discover:
        MainShell.goTo(context, MainShell.discover);
      case Routes.medicine:
        final premium = AppStateScope.of(context).isPremium;
        Navigator.of(context)
            .pushNamed(premium ? Routes.medList : Routes.medPaywall);
      case final String route:
        Navigator.of(context).pushNamed(route);
      case null:
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('${tool.title.replaceAll('\n', ' ')} — coming soon'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: 'Tools',
          onBack: () => MainShell.goTo(context, MainShell.home),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                sliver: SliverGrid.builder(
                  itemCount: MockData.tools.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 22,
                    mainAxisExtent: 130,
                  ),
                  itemBuilder: (context, i) {
                    final tool = MockData.tools[i];
                    return _ToolTile(tool: tool, onTap: () => _open(context, tool));
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 28, 14, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                      title: 'Relaxation Activities', onAll: () {}),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110 + 28,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.relaxation.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) =>
                        _MediaCard(item: MockData.relaxation[i]),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                      title: 'Pre-recorded webinar videos', onAll: () {}),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 130 + 28,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.webinars.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) =>
                        _WebinarCard(item: MockData.webinars[i]),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: MainShell.contentBottomInset),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.tool, required this.onTap});

  final ToolItem tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PhotoCard(
      image: tool.image,
      radius: 18,
      onTap: onTap,
      scrim: [
        const Color(0x263C0A64),
        const Color(0x702B0653),
        tool.darkScrim ? const Color(0xB8280550) : const Color(0x75D51065),
      ],
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Text(
            tool.title,
            style: AppText.l(14,
                weight: FontWeight.w700, color: Colors.white, height: 1.25),
          ),
        ),
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return PhotoCard(
      image: item.image,
      width: 150,
      height: 110,
      onTap: () {},
      scrim: const [
        Color(0x0D1E053C),
        Color(0x3826054D),
        Color(0x6627054F),
        Color(0xBF280550),
      ],
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.l(12,
                      weight: FontWeight.w700, color: Colors.white)),
              if (item.subtitle.isNotEmpty)
                Text(item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.l(12, color: const Color(0xBFFFFFFF))),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebinarCard extends StatelessWidget {
  const _WebinarCard({required this.item});

  final WebinarItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: 160,
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: item.gradient,
          ),
        ),
        child: InkWell(
          onTap: () {},
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x1AFFFFFF),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(item.tag,
                          style: AppText.l(9,
                              weight: FontWeight.w700,
                              color: const Color(0xE6FFFFFF))),
                    ),
                    const SizedBox(height: 8),
                    Text(item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.l(14,
                            weight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.25)),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.meta,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.l(12,
                                  color: const Color(0xBFFFFFFF))),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x40FFFFFF),
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
