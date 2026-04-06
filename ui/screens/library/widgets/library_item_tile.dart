import 'package:flutter/material.dart';
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
              SizedBox(width: 20),
              Text(data.artist.name),
              SizedBox(width: 20),
              Text(data.artist.genre),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data.song.imageUrl.toString()),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isPlaying)
                  const Text(
                    "Playing",
                    style: TextStyle(color: Colors.amber),
                  ),
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
