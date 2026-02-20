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
    };
  }
}
