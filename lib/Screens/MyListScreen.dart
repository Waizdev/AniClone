import 'package:flutter/material.dart';
import 'package:projects/Screens/AnimeDetailScreen.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/services/my_list_storage.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MyListStorage.instance,
      builder: (context, _) {
        final myList = MyListStorage.instance.animeList;

        if (myList.isEmpty) {
          return const Center(
            child: Text("No anime in My List yet"),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: myList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final anime = myList[index];
            return _MyListTile(anime: anime);
          },
        );
      },
    );
  }
}

class _MyListTile extends StatelessWidget {
  const _MyListTile({required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnimeDetailScreen(anime: anime),
            ),
          );
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 52,
            height: 52,
            child: Image.network(
              anime.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          anime.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${anime.type} • Score ${anime.score}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.bookmark_remove,
            color: Colors.redAccent,
          ),
          tooltip: "Remove from My List",
          onPressed: () async {
            await MyListStorage.instance.removeAnime(anime);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${anime.title} removed from My List"),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
