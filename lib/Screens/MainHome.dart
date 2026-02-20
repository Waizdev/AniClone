import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projects/Components/AnimeBanner.dart';
import 'package:projects/Components/HorizontalComponents.dart';
import 'package:projects/api/JikanService.dart';
import 'package:projects/models/anime.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final JikanService api = JikanService();
  late final Future<Map<String, List<Anime>>> _sectionsFuture;
  final PageController _bannerController = PageController();
  Timer? _autoScrollTimer;
  int _bannerCount = 0;
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _sectionsFuture = api.getAllSections();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _syncAutoScroll(int bannerCount) {
    if (_bannerCount == bannerCount) return;
    _bannerCount = bannerCount;

    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;

    if (_bannerCount <= 1) return;

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerController.hasClients || _bannerCount <= 1) {
        return;
      }
      final nextPage = (_currentBannerIndex + 1) % _bannerCount;
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Anime>>>(
      future: _sectionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No Data Found"));
        }

        final trending = snapshot.data!['trending'] ?? [];
        final topAiring = snapshot.data!['topAiring'] ?? [];
        final mostPopular = snapshot.data!['mostPopular'] ?? [];
        final topTV = snapshot.data!['topTV'] ?? [];
        final trendingTop5 = trending.take(5).toList();
        _syncAutoScroll(trendingTop5.length);

        return ListView(
          children: [
            // 🔥 Banner
            if (trendingTop5.isNotEmpty)
              SizedBox(
                height: 360,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _bannerController,
                        itemCount: trendingTop5.length,
                        onPageChanged: (index) =>
                            setState(() => _currentBannerIndex = index),
                        itemBuilder: (context, index) =>
                            AnimeBanner(anime: trendingTop5[index]),
                      ),
                    ),
                    if (trendingTop5.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          trendingTop5.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            width: _currentBannerIndex == index ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentBannerIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // 📺 Sections
            if (topAiring.isNotEmpty)
              HorizontalAnimeSection(
                title: "Top Airing",
                animeList: topAiring,
              ),

            if (mostPopular.isNotEmpty)
              HorizontalAnimeSection(
                title: "Most Popular",
                animeList: mostPopular,
              ),

            if (topTV.isNotEmpty)
              HorizontalAnimeSection(
                title: "Top TV Series",
                animeList: topTV,
              ),
          ],
        );
      },
    );
  }
}
