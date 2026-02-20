import 'package:flutter/material.dart';
import 'package:projects/api/JikanService.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/Components/AnimeBanner.dart';
import 'package:projects/Components/HorizontalComponents.dart';
class MainHome extends StatelessWidget {
  final JikanService api = JikanService();

  MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Anime>>>(
      future: api.getAllSections(),
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

        return ListView(
          children: [

            // 🔥 Banner
            if (trending.isNotEmpty)
              AnimeBanner(anime: trending.first),

            // 📺 Sections
            HorizontalAnimeSection(
              title: "Top Airing",
              animeList: topAiring,
            ),

            HorizontalAnimeSection(
              title: "Most Popular",
              animeList: mostPopular,
            ),

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
