// lib/models/anime.dart
class Anime {
  final int malId; // MyAnimeList ID
  final String title; // Anime title
  final String imageUrl; // Poster image URL
  final String type; // TV, Movie, OVA, etc.
  final double score; // Rating/score
  final String status; // Airing status
  final int episodes; // Number of episodes
  final String url; // Link to MyAnimeList page
  final String synopsis;
  final String titleEnglish;
  final String titleJapanese;
  final List<String> titleSynonyms;
  final String source;
  final bool airing;
  final String airedString;
  final String duration;
  final String rating;
  final int scoredBy;
  final int rank;
  final int popularity;
  final int members;
  final int favorites;
  final String background;
  final String season;
  final int year;
  final String broadcast;
  final List<String> producers;
  final List<String> licensors;
  final List<String> studios;
  final List<String> genres;
  final List<String> themes;
  final List<String> demographics;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.score,
    required this.status,
    required this.episodes,
    required this.url,
    required this.synopsis,
    this.titleEnglish = '',
    this.titleJapanese = '',
    this.titleSynonyms = const [],
    this.source = '',
    this.airing = false,
    this.airedString = '',
    this.duration = '',
    this.rating = '',
    this.scoredBy = 0,
    this.rank = 0,
    this.popularity = 0,
    this.members = 0,
    this.favorites = 0,
    this.background = '',
    this.season = '',
    this.year = 0,
    this.broadcast = '',
    this.producers = const [],
    this.licensors = const [],
    this.studios = const [],
    this.genres = const [],
    this.themes = const [],
    this.demographics = const [],
  });

  // Factory constructor to parse JSON data from Jikan API
  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'],
      title: json['title'] ?? 'N/A',
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      type: json['type'] ?? 'N/A',
      score: (json['score'] != null) ? (json['score'] as num).toDouble() : 0.0,
      status: json['status'] ?? 'N/A',
      episodes: json['episodes'] ?? 0,
      url: json['url'] ?? '',
      synopsis: json['synopsis'] ?? '',
      titleEnglish: json['title_english'] ?? '',
      titleJapanese: json['title_japanese'] ?? '',
      titleSynonyms: _parseStringList(json['title_synonyms']),
      source: json['source'] ?? '',
      airing: json['airing'] ?? false,
      airedString: json['aired']?['string'] ?? '',
      duration: json['duration'] ?? '',
      rating: json['rating'] ?? '',
      scoredBy: json['scored_by'] ?? 0,
      rank: json['rank'] ?? 0,
      popularity: json['popularity'] ?? 0,
      members: json['members'] ?? 0,
      favorites: json['favorites'] ?? 0,
      background: json['background'] ?? '',
      season: json['season'] ?? '',
      year: json['year'] ?? 0,
      broadcast: json['broadcast']?['string'] ?? '',
      producers: _parseNamedList(json['producers']),
      licensors: _parseNamedList(json['licensors']),
      studios: _parseNamedList(json['studios']),
      genres: _parseNamedList(json['genres']),
      themes: _parseNamedList(json['themes']),
      demographics: _parseNamedList(json['demographics']),
    );
  }

  factory Anime.fromStorageMap(Map<String, dynamic> json) {
    return Anime(
      malId: json['malId'] ?? 0,
      title: json['title'] ?? 'N/A',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? 'N/A',
      score: (json['score'] != null) ? (json['score'] as num).toDouble() : 0.0,
      status: json['status'] ?? 'N/A',
      episodes: json['episodes'] ?? 0,
      url: json['url'] ?? '',
      synopsis: json['synopsis'] ?? '',
      titleEnglish: json['titleEnglish'] ?? '',
      titleJapanese: json['titleJapanese'] ?? '',
      titleSynonyms: _parseStringList(json['titleSynonyms']),
      source: json['source'] ?? '',
      airing: json['airing'] ?? false,
      airedString: json['airedString'] ?? '',
      duration: json['duration'] ?? '',
      rating: json['rating'] ?? '',
      scoredBy: json['scoredBy'] ?? 0,
      rank: json['rank'] ?? 0,
      popularity: json['popularity'] ?? 0,
      members: json['members'] ?? 0,
      favorites: json['favorites'] ?? 0,
      background: json['background'] ?? '',
      season: json['season'] ?? '',
      year: json['year'] ?? 0,
      broadcast: json['broadcast'] ?? '',
      producers: _parseStringList(json['producers']),
      licensors: _parseStringList(json['licensors']),
      studios: _parseStringList(json['studios']),
      genres: _parseStringList(json['genres']),
      themes: _parseStringList(json['themes']),
      demographics: _parseStringList(json['demographics']),
    );
  }

  Map<String, dynamic> toStorageMap() {
    return {
      'malId': malId,
      'title': title,
      'imageUrl': imageUrl,
      'type': type,
      'score': score,
      'status': status,
      'episodes': episodes,
      'url': url,
      'synopsis': synopsis,
      'titleEnglish': titleEnglish,
      'titleJapanese': titleJapanese,
      'titleSynonyms': titleSynonyms,
      'source': source,
      'airing': airing,
      'airedString': airedString,
      'duration': duration,
      'rating': rating,
      'scoredBy': scoredBy,
      'rank': rank,
      'popularity': popularity,
      'members': members,
      'favorites': favorites,
      'background': background,
      'season': season,
      'year': year,
      'broadcast': broadcast,
      'producers': producers,
      'licensors': licensors,
      'studios': studios,
      'genres': genres,
      'themes': themes,
      'demographics': demographics,
    };
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item?.toString() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static List<String> _parseNamedList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => item['name']?.toString() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }
}
