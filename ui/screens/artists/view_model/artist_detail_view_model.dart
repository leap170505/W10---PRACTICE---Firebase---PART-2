import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final SongRepository songRepository;
  final Artist artist;

  AsyncValue<List<Song>> songs = AsyncValue.loading();
  AsyncValue<List<Comment>> comments = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.songRepository,
    required this.artist,
  }) {
    _init();
  }

  void _init() {
    fetchData();
  }

  void fetchData() async {
    // 1- Fetch songs
    try {
      final artistSongs = await songRepository.fetchSongsByArtist(artist.id);
      songs = AsyncValue.success(artistSongs);
    } catch (e) {
      songs = AsyncValue.error(e);
    }
    notifyListeners();

    // 2- Fetch comments
    try {
      final artistComments = await artistRepository.fetchComments(artist.id);
      comments = AsyncValue.success(artistComments);
    } catch (e) {
      comments = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> postComment(String text) async {
    if (text.trim().isEmpty) return;

    try {
      await artistRepository.addComment(artist.id, text);
      // Refresh comments after posting
      final artistComments = await artistRepository.fetchComments(artist.id);
      comments = AsyncValue.success(artistComments);
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }
}
