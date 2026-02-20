import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class JikanService {
  final String baseUrl = "https://api.jikan.moe/v4";

  Future<Map<String, List<Anime>>> getAllSections() async {
    final trending = await getTrending();
    await Future.delayed(const Duration(milliseconds: 800));
    final topAiring = await getTopAiring();
    await Future.delayed(const Duration(milliseconds: 800));
    final mostPopular = await getMostPopular();
    await Future.delayed(const Duration(milliseconds: 800));
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
    await Future.delayed(const Duration(milliseconds: 600));
    return _fetchAnimeList(url);
  }

  Future<List<Anime>> getTopAiring() async {
    final url = Uri.parse("$baseUrl/seasons/now");
    await Future.delayed(const Duration(milliseconds: 650));
    return _fetchAnimeList(url, isSeason: true);
  }

  Future<List<Anime>> getMostPopular() async {
    final url = Uri.parse("$baseUrl/top/anime?filter=bypopularity");
    await Future.delayed(const Duration(milliseconds: 700));
    return _fetchAnimeList(url);
  }

  Future<List<Anime>> getTopTVSeries() async {
    final url = Uri.parse("$baseUrl/top/anime?type=tv");
    await Future.delayed(const Duration(milliseconds: 800));
    return _fetchAnimeList(url);
  }

  Future<List<Anime>> _fetchAnimeList(Uri url, {bool isSeason = false}) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> dataList;

        if (isSeason) {
          dataList = jsonData["data"];
          dataList = dataList.map((item) => item["anime"] ?? []).expand((x) => x).toList();
        } else {
          dataList = jsonData["data"];
        }

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
