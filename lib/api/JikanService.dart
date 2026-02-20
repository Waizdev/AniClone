import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';
import '../models/paginated_anime_response.dart';

class JikanService {
  final String baseUrl = "https://api.jikan.moe/v4";

  Future<Map<String, List<Anime>>> getAllSections() async {
    final trending = await getTrending();
    final topAiring = await getTopAiring();
    final mostPopular = await getMostPopular();
    final topTV = await getTopTVSeries();

    return {
      "trending": trending,
      "topAiring": topAiring,
      "mostPopular": mostPopular,
      "topTV": topTV,
    };
  }

  Future<List<Anime>> getTrending() async {
    final url = Uri.parse("$baseUrl/top/anime");
    return _fetchAnimeList(url);
  }

  Future<List<Anime>> searchAnime(String query, {int limit = 25}) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return [];

    final url = Uri.parse("$baseUrl/anime").replace(
      queryParameters: {
        'q': trimmedQuery,
        'limit': '$limit',
      },
    );
    return _fetchAnimeList(url);
  }

  Future<List<Anime>> getScheduleByDay(
    String day, {
    int page = 1,
    int limit = 25,
  }) async {
    final normalizedDay = day.toLowerCase().trim();
    final allowedDays = <String>{
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    };
    if (!allowedDays.contains(normalizedDay)) return [];

    final url = Uri.parse("$baseUrl/schedules").replace(
      queryParameters: {
        'filter': normalizedDay,
        'page': '$page',
        'limit': '$limit',
      },
    );
    return _fetchAnimeList(url);
  }

  Future<List<Anime>> getTopAiring() async {
    final response = await getTopAiringPage(page: 1);
    return response.data;
  }

  Future<List<Anime>> getMostPopular() async {
    final response = await getMostPopularPage(page: 1);
    return response.data;
  }

  Future<List<Anime>> getTopTVSeries() async {
    final response = await getTopTVSeriesPage(page: 1);
    return response.data;
  }

  Future<PaginatedAnimeResponse> getTopAiringPage({
    required int page,
    int limit = 25,
  }) async {
    final url = Uri.parse("$baseUrl/top/anime").replace(
      queryParameters: {
        'filter': 'airing',
        'page': '$page',
        'limit': '$limit',
      },
    );
    return _fetchAnimePage(url);
  }

  Future<PaginatedAnimeResponse> getMostPopularPage({
    required int page,
    int limit = 25,
  }) async {
    final url = Uri.parse("$baseUrl/top/anime").replace(
      queryParameters: {
        'filter': 'bypopularity',
        'page': '$page',
        'limit': '$limit',
      },
    );
    return _fetchAnimePage(url);
  }

  Future<PaginatedAnimeResponse> getTopTVSeriesPage({
    required int page,
    int limit = 25,
  }) async {
    final url = Uri.parse("$baseUrl/top/anime").replace(
      queryParameters: {
        'type': 'tv',
        'page': '$page',
        'limit': '$limit',
      },
    );
    return _fetchAnimePage(url);
  }

  Future<PaginatedAnimeResponse> _fetchAnimePage(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final pagination =
            jsonData['pagination'] as Map<String, dynamic>? ?? {};
        final currentPage = (pagination['current_page'] as num?)?.toInt() ?? 1;
        final lastVisiblePage =
            (pagination['last_visible_page'] as num?)?.toInt() ?? currentPage;
        final hasNextPage = pagination['has_next_page'] as bool? ?? false;
        final dataList = (jsonData['data'] as List<dynamic>? ?? const []);
        final data = dataList
            .map((json) => Anime.fromJson(json as Map<String, dynamic>))
            .toList();

        return PaginatedAnimeResponse(
          data: data,
          currentPage: currentPage,
          lastVisiblePage: lastVisiblePage,
          hasNextPage: hasNextPage,
        );
      }
      return PaginatedAnimeResponse.empty();
    } catch (e) {
      print("Error fetching anime page: $e");
      return PaginatedAnimeResponse.empty();
    }
  }

  Future<List<Anime>> _fetchAnimeList(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> dataList = jsonData["data"];
        return dataList.map<Anime>((json) => Anime.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching anime: $e");
      return [];
    }
  }
}
