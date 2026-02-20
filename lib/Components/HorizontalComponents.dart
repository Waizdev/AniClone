import 'package:flutter/material.dart';
import 'animeCard.dart';
import 'package:projects/Screens/SectionAnimeListScreen.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/models/home_section_type.dart';

class HorizontalAnimeSection extends StatelessWidget {
  final String title;
  final List<Anime> animeList;
  final HomeSectionType sectionType;

  const HorizontalAnimeSection({
    super.key,
    required this.title,
    required this.animeList,
    required this.sectionType,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SectionAnimeListScreen(
                          sectionType: sectionType,
                          title: title,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (animeList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('No anime available'),
            )
          else
            SizedBox(
              height: 200,
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
