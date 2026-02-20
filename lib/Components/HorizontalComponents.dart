import 'package:flutter/material.dart';
import 'AnimeCard.dart';
import 'package:projects/models/anime.dart'; 

class HorizontalAnimeSection extends StatelessWidget {
  final String title;
  final List<Anime> animeList;

  const HorizontalAnimeSection({
    super.key,
    required this.title,
    required this.animeList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Horizontal List of Anime Cards
          SizedBox(
            height: 180, 
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: animeList.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final anime = animeList[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: AnimeCard(anime: anime),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
