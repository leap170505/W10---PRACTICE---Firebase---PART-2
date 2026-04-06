import 'package:flutter/material.dart';
import '../../artists/artist_detail_screen.dart';
import '../view_model/library_item_data.dart';

class LibraryItemTile extends StatelessWidget {
  final LibraryItemData data;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const LibraryItemTile({
    super.key,
    required this.data,
    required this.isPlaying,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(data.song.title),
          subtitle: Row(
            children: [
              Text("${data.song.duration.inMinutes} mins"),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArtistDetailScreen(artist: data.artist),
                    ),
                  );
                },
                child: Text(
                  data.artist.name,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(data.artist.genre),
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtistDetailScreen(artist: data.artist),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(data.song.imageUrl.toString()),
            ),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isPlaying)
                  const Text("Playing", style: TextStyle(color: Colors.amber)),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onLike,
                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                ),
                Text("${data.song.likes}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
