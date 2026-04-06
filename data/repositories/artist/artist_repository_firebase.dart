import 'dart:convert';

import 'package:http/http.dart' as http;
 
import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  List<Artist>? _cachedArtists;

  final Uri artistsUri = Uri.https(
    'week-8-practice-453c9-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }

      _cachedArtists = result;

      return result;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final artists = await fetchArtists();
    return artists.firstWhere((artist) => artist.id == id);
  }

  @override
  Future<List<Comment>> fetchComments(String artistId) async {
    final Uri commentsUri = Uri.https(
      'week-8-practice-453c9-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments/$artistId.json',
    );

    final response = await http.get(commentsUri);

    if (response.statusCode == 200 && response.body != 'null') {
      Map<String, dynamic> commentsJson = json.decode(response.body);
      List<Comment> result = [];
      for (final entry in commentsJson.entries) {
        result.add(CommentDto.fromJson(entry.key, entry.value));
      }
      return result;
    }
    return [];
  }

  @override
  Future<void> addComment(String artistId, String text) async {
    final Uri commentsUri = Uri.https(
      'week-8-practice-453c9-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments/$artistId.json',
    );

    final comment = Comment(
      id: '',
      artistId: artistId,
      text: text,
      timestamp: DateTime.now(),
    );

    final response = await http.post(
      commentsUri,
      body: json.encode(CommentDto.toJson(comment)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }
}
