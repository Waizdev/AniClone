import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projects/models/anime.dart';

class MyListStorage extends ChangeNotifier {
  MyListStorage._internal() {
    _box.listenKey(_storageKey, (_) {
      notifyListeners();
    });
  }

  static final MyListStorage instance = MyListStorage._internal();

  static const String _storageKey = 'my_list_anime';
  final GetStorage _box = GetStorage();

  List<Anime> get animeList {
    final raw = _box.read<List<dynamic>>(_storageKey) ?? <dynamic>[];
    return raw
        .whereType<Map>()
        .map((item) => Anime.fromStorageMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  bool isAdded(Anime anime) {
    return animeList.any((item) => item.malId == anime.malId);
  }

  Future<void> addAnime(Anime anime) async {
    final list = _readStorageMaps();
    final exists = list.any((item) => item['malId'] == anime.malId);
    if (exists) return;

    list.add(anime.toStorageMap());
    await _box.write(_storageKey, list);
  }

  Future<void> removeAnime(Anime anime) async {
    final list = _readStorageMaps();
    list.removeWhere((item) => item['malId'] == anime.malId);
    await _box.write(_storageKey, list);
  }

  List<Map<String, dynamic>> _readStorageMaps() {
    final raw = _box.read<List<dynamic>>(_storageKey) ?? <dynamic>[];
    return raw.whereType<Map>().map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();
  }
}
