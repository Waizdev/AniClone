import 'package:flutter/material.dart';
import 'package:projects/Screens/AnimeDetailScreen.dart';
import 'package:projects/api/JikanService.dart';
import 'package:projects/models/anime.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final JikanService _api = JikanService();

  List<Anime> _results = <Anime>[];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _results = <Anime>[];
        _isLoading = false;
        _hasSearched = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _error = null;
    });

    try {
      final response = await _api.searchAnime(trimmed);
      if (!mounted) return;
      setState(() {
        _results = response;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = "Failed to fetch results. Please try again.";
      });
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _search(_searchController.text),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasSearched) {
      return const Center(
        child: Text("Search anime by title"),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Text("No anime found"),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final anime = _results[index];
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Anime'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Anime',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _search(_searchController.text),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }
}
