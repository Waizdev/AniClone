import 'package:flutter/material.dart';
import 'package:projects/Components/animeCard.dart';
import 'package:projects/api/JikanService.dart';
import 'package:projects/models/anime.dart';
import 'package:projects/models/home_section_type.dart';
import 'package:projects/models/paginated_anime_response.dart';

class SectionAnimeListScreen extends StatefulWidget {
  const SectionAnimeListScreen({
    super.key,
    required this.sectionType,
    required this.title,
  });

  final HomeSectionType sectionType;
  final String title;

  @override
  State<SectionAnimeListScreen> createState() => _SectionAnimeListScreenState();
}

class _SectionAnimeListScreenState extends State<SectionAnimeListScreen> {
  static const int _pageSize = 25;
  static const double _loadMoreThreshold = 300;

  final JikanService _api = JikanService();
  final ScrollController _scrollController = ScrollController();

  final List<Anime> _items = <Anime>[];
  int _page = 1;
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _requestToken = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFirstPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (!_hasMore || _isLoadingInitial || _isLoadingMore) return;

    final remaining = _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (remaining <= _loadMoreThreshold) {
      _loadNextPage();
    }
  }

  Future<PaginatedAnimeResponse> _fetchByType(int page) {
    switch (widget.sectionType) {
      case HomeSectionType.topAiring:
        return _api.getTopAiringPage(page: page, limit: _pageSize);
      case HomeSectionType.mostPopular:
        return _api.getMostPopularPage(page: page, limit: _pageSize);
      case HomeSectionType.topTvSeries:
        return _api.getTopTVSeriesPage(page: page, limit: _pageSize);
    }
  }

  void _loadFirstPage() {
    _loadPage(refresh: true);
  }

  Future<void> _loadNextPage() async {
    await _loadPage(refresh: false);
  }

  Future<void> _loadPage({required bool refresh}) async {
    if (refresh) {
      setState(() {
        _isLoadingInitial = true;
        _isLoadingMore = false;
        _error = null;
      });
    } else {
      if (_isLoadingInitial || _isLoadingMore || !_hasMore) return;
      setState(() {
        _isLoadingMore = true;
        _error = null;
      });
    }

    final int targetPage = refresh ? 1 : _page;
    final int token = ++_requestToken;

    try {
      final fetchedResponse = await _fetchByType(targetPage);
      if (!mounted || token != _requestToken) return;

      final fetched = fetchedResponse.data;
      final existingIds =
          refresh ? <int>{} : _items.map((anime) => anime.malId).toSet();
      final deduped =
          fetched.where((anime) => !existingIds.contains(anime.malId)).toList();

      setState(() {
        if (refresh) {
          _items
            ..clear()
            ..addAll(deduped);
        } else {
          _items.addAll(deduped);
        }
        _page = fetchedResponse.currentPage + 1;
        _hasMore = fetchedResponse.hasNextPage;
        _isLoadingInitial = false;
        _isLoadingMore = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted || token != _requestToken) return;
      setState(() {
        _isLoadingInitial = false;
        _isLoadingMore = false;
        _error = 'Failed to load anime. Please try again.';
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadPage(refresh: true);
  }

  Widget _buildInitialError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_error ?? 'Something went wrong'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loadFirstPage,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineRetry() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error ?? 'Failed to load more'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadNextPage,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasInitialError = _error != null && _items.isEmpty;
    final hasPaginationError = _error != null && _items.isNotEmpty;
    final showFooter = _isLoadingMore || hasPaginationError;
    final itemCount = _items.length + (showFooter ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          if (_isLoadingInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (hasInitialError) {
            return _buildInitialError();
          }

          if (_items.isEmpty) {
            return const Center(child: Text('No anime found'));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: GridView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index >= _items.length) {
                  if (_isLoadingMore) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildInlineRetry();
                }
                return AnimeCard(anime: _items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
