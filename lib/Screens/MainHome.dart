import 'package:flutter/material.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/api/JikanService.dart';
import '../Components/AnimeCard.dart';
import '../Components/AnimeBanner.dart';
import 'package:projects/Components/HorizontalComponents.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late Future<Map<String, List<Anime>>> allAnimeFuture;
  final JikanService api = JikanService();

  @override
  void initState() {
    super.initState();
    allAnimeFuture = api.getAllSections();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Anime>>>(
      future: allAnimeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found'));
        } else {
          final trending = snapshot.data!['trending'] ?? [];
          final topAiring = snapshot.data!['topAiring'] ?? [];
          final mostPopular = snapshot.data!['mostPopular'] ?? [];
          final topTV = snapshot.data!['topTV'] ?? [];

          // Use the first trending anime as the banner
          final featuredAnime = trending.isNotEmpty ? trending[0] : null;

          return ListView(
            children: [
              if (featuredAnime != null)
                AnimeBanner(anime: featuredAnime),

              // Top Airing Section
              HorizontalAnimeSection(
                title: "Top Airing",
                animeList: topAiring,
              ),

              // Most Popular Section
              HorizontalAnimeSection(
                title: "Most Popular",
                animeList: mostPopular,
              ),

              // Most Favorite Section (sort by score descending)
              HorizontalAnimeSection(
                title: "Most Favorite",
                animeList: List.from(topAiring)..sort((a, b) => b.score.compareTo(a.score)),
              ),

              // Top TV Series Section
              HorizontalAnimeSection(
                title: "Top TV Series",
                animeList: topTV,
              ),
            ],
          );
        }
      },
    );
  }
}
