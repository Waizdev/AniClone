import 'package:flutter/material.dart';
import 'package:projects/Screens/AnimeDetailScreen.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/services/my_list_storage.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;

  const AnimeCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MyListStorage.instance,
      builder: (context, _) {
        final isAdded = MyListStorage.instance.isAdded(anime);

        return SizedBox(
          width: 130,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeDetailScreen(anime: anime),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            anime.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "HD",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: IconButton(
                            onPressed: () async {
                              if (isAdded) {
                                await MyListStorage.instance.removeAnime(anime);
                              } else {
                                await MyListStorage.instance.addAnime(anime);
                              }

                              if (!context.mounted) return;
                              final action =
                                  isAdded ? "removed from" : "added to";
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("${anime.title} $action My List"),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: Icon(
                              isAdded ? Icons.bookmark : Icons.bookmark_border,
                              color: isAdded ? Colors.amber : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            anime.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
