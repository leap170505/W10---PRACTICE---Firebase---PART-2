import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> data = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong({bool forceFetch = false}) async {
    if (forceFetch || data.state != AsyncValueState.success) {
      data = AsyncValue.loading();
      notifyListeners();
    }

    try {
      List<Song> songs = await songRepository.fetchSongs(forceFetch: forceFetch);

      List<Artist> artists =
          await artistRepository.fetchArtists(forceFetch: forceFetch);

      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = songs
          .map(
            (song) =>
                LibraryItemData(song: song, artist: mapArtist[song.artistId]!),
          )
          .toList();

      this.data = AsyncValue.success(data);
    } catch (e) {
      data = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void toggleLike(Song song) async {
    if (data.state != AsyncValueState.success) return;

    final originalItems = data.data!;

    final List<LibraryItemData> updatedItems = originalItems.map((item) {
      if (item.song.id == song.id) {
        return LibraryItemData(
          song: item.song.copyWith(likes: item.song.likes + 1),
          artist: item.artist,
        );
      }
      return item;
    }).toList();

    data = AsyncValue.success(updatedItems);
    notifyListeners();

    try {
      await songRepository.likeSong(song.id);
    } catch (e) {
      data = AsyncValue.success(originalItems);
      notifyListeners();
    }
  }


  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
