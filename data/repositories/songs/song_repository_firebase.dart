import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  List<Song>? _cachedSongs;

  final Uri songsUri = Uri.https(
    'week-8-practice-453c9-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {

    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {

      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }

      _cachedSongs = result;

      return result;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<void> likeSong(String id) async {
    final Uri likesUri = Uri.https(
      'week-8-practice-453c9-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$id/likes.json',
    );

    final fetchResponse = await http.get(likesUri);
    int currentLikes = 0;
    if (fetchResponse.statusCode == 200 && fetchResponse.body != 'null') {
      currentLikes = json.decode(fetchResponse.body);
    }

    final response = await http.put(
      likesUri,
      body: json.encode(currentLikes + 1),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update likes');
    }
  }

  @override
  Future<List<Song>> fetchSongsByArtist(String artistId) async {
    final allSongs = await fetchSongs();
    return allSongs.where((song) => song.artistId == artistId).toList();
  }
}
