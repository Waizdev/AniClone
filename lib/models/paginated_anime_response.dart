import 'package:projects/models/anime.dart';

class PaginatedAnimeResponse {
  PaginatedAnimeResponse({
    required this.data,
    required this.currentPage,
    required this.lastVisiblePage,
    required this.hasNextPage,
  });

  final List<Anime> data;
  final int currentPage;
  final int lastVisiblePage;
  final bool hasNextPage;

  factory PaginatedAnimeResponse.empty() {
    return PaginatedAnimeResponse(
      data: const [],
      currentPage: 1,
      lastVisiblePage: 1,
      hasNextPage: false,
    );
  }
}
