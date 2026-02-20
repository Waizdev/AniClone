import 'package:flutter/material.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/services/my_list_storage.dart';

class AnimeDetailScreen extends StatelessWidget {
  const AnimeDetailScreen({super.key, required this.anime});

  final Anime anime;

  String _asText(String value) => value.trim().isEmpty ? 'N/A' : value;
  String _asNumber(int value) => value > 0 ? value.toString() : 'N/A';

  @override
  Widget build(BuildContext context) {
    final chips = <String>[
      ...anime.genres,
      ...anime.themes,
      ...anime.demographics,
    ];

    return AnimatedBuilder(
      animation: MyListStorage.instance,
      builder: (context, _) {
        final isAdded = MyListStorage.instance.isAdded(anime);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              anime.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  if (isAdded) {
                    await MyListStorage.instance.removeAnime(anime);
                  } else {
                    await MyListStorage.instance.addAnime(anime);
                  }

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isAdded
                            ? "${anime.title} removed from My List"
                            : "${anime.title} added to My List",
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  isAdded ? Icons.bookmark : Icons.bookmark_add_outlined,
                ),
                label: Text(isAdded ? 'Added' : 'Add to List'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      anime.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  anime.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                    label: 'English Title', value: _asText(anime.titleEnglish)),
                _InfoRow(
                    label: 'Japanese Title',
                    value: _asText(anime.titleJapanese)),
                _InfoRow(
                  label: 'Synonyms',
                  value: anime.titleSynonyms.isEmpty
                      ? 'N/A'
                      : anime.titleSynonyms.join(', '),
                ),
                _InfoRow(label: 'Type', value: _asText(anime.type)),
                _InfoRow(label: 'Source', value: _asText(anime.source)),
                _InfoRow(label: 'Status', value: _asText(anime.status)),
                _InfoRow(label: 'Airing', value: anime.airing ? 'Yes' : 'No'),
                _InfoRow(label: 'Episodes', value: _asNumber(anime.episodes)),
                _InfoRow(label: 'Aired', value: _asText(anime.airedString)),
                _InfoRow(label: 'Duration', value: _asText(anime.duration)),
                _InfoRow(label: 'Rating', value: _asText(anime.rating)),
                _InfoRow(
                  label: 'Score',
                  value:
                      anime.score > 0 ? anime.score.toStringAsFixed(2) : 'N/A',
                ),
                _InfoRow(label: 'Scored By', value: _asNumber(anime.scoredBy)),
                _InfoRow(label: 'Rank', value: _asNumber(anime.rank)),
                _InfoRow(
                    label: 'Popularity', value: _asNumber(anime.popularity)),
                _InfoRow(label: 'Members', value: _asNumber(anime.members)),
                _InfoRow(label: 'Favorites', value: _asNumber(anime.favorites)),
                _InfoRow(
                  label: 'Season / Year',
                  value: anime.season.isEmpty && anime.year == 0
                      ? 'N/A'
                      : '${_asText(anime.season)} ${anime.year == 0 ? '' : anime.year}',
                ),
                _InfoRow(label: 'Broadcast', value: _asText(anime.broadcast)),
                _InfoRow(
                  label: 'Studios',
                  value:
                      anime.studios.isEmpty ? 'N/A' : anime.studios.join(', '),
                ),
                _InfoRow(
                  label: 'Producers',
                  value: anime.producers.isEmpty
                      ? 'N/A'
                      : anime.producers.join(', '),
                ),
                _InfoRow(
                  label: 'Licensors',
                  value: anime.licensors.isEmpty
                      ? 'N/A'
                      : anime.licensors.join(', '),
                ),
                _InfoRow(label: 'MAL URL', value: _asText(anime.url)),
                const SizedBox(height: 12),
                Text(
                  'Synopsis',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(_asText(anime.synopsis)),
                const SizedBox(height: 12),
                Text(
                  'Background',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(_asText(anime.background)),
                const SizedBox(height: 12),
                if (chips.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: chips
                        .map((item) => Chip(label: Text(item)))
                        .toList(growable: false),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
