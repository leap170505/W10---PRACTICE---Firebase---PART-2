import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});
  
  Future<Artist?> fetchArtistById(String id);

  Future<List<Comment>> fetchComments(String artistId);

  Future<void> addComment(String artistId, String text);
}
