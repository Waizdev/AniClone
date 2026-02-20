// lib/components/anime_card.dart
import 'package:flutter/material.dart';
import 'package:projects/models/anime.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;

  const AnimeCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // fixed width for horizontal scroll
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Anime Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              anime.imageUrl,
              width: 120,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          // Anime Title
          Text(
            anime.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
