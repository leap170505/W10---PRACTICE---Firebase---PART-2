import '../../model/comment/comment.dart';

class CommentDto {
  static const String textKey = 'text';
  static const String timestampKey = 'timestamp';
  static const String artistIdKey = 'artistId';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    return Comment(
      id: id,
      artistId: json[artistIdKey] ?? '',
      text: json[textKey] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(json[timestampKey] ?? 0),
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      artistIdKey: comment.artistId,
      textKey: comment.text,
      timestampKey: comment.timestamp.millisecondsSinceEpoch,
    };
  }
}
