import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/artist/artist_repository.dart';
import '../../../data/repositories/songs/song_repository.dart';
import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import '../../theme/theme.dart';
import '../../utils/async_value.dart';
import 'view_model/artist_detail_view_model.dart';

class ArtistDetailScreen extends StatelessWidget {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistDetailViewModel(
        artistRepository: context.read<ArtistRepository>(),
        songRepository: context.read<SongRepository>(),
        artist: artist,
      ),
      child: _ArtistDetailScreenContent(),
    );
  }
}

class _ArtistDetailScreenContent extends StatefulWidget {
  @override
  State<_ArtistDetailScreenContent> createState() => _ArtistDetailScreenContentState();
}

class _ArtistDetailScreenContentState extends State<_ArtistDetailScreenContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArtistDetailViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(viewModel.artist.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: CustomScrollView(
        slivers: [
          // 1- Artist Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(viewModel.artist.imageUrl.toString()),
                  ),
                  const SizedBox(height: 16),
                  Text(viewModel.artist.name, style: AppTextStyles.heading),
                  Text(viewModel.artist.genre, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),

          // 2- Songs Section
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("Top Songs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          _buildSongsList(viewModel),

          // 3- Comments Section
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 8.0),
              child: Text("Comments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          _buildCommentsList(viewModel),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: _buildCommentInput(viewModel),
    );
  }

  Widget _buildSongsList(ArtistDetailViewModel viewModel) {
    final state = viewModel.songs;
    if (state.state == AsyncValueState.loading) {
      return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
    }
    if (state.state == AsyncValueState.error) {
      return SliverToBoxAdapter(child: Center(child: Text('Error: ${state.error}')));
    }

    final songs = state.data ?? [];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final song = songs[index];
          return ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(song.title),
            subtitle: Text(song.duration.toString().split('.').first.padLeft(8, "0")),
            trailing: Text("${song.likes} likes"),
          );
        },
        childCount: songs.length,
      ),
    );
  }

  Widget _buildCommentsList(ArtistDetailViewModel viewModel) {
    final state = viewModel.comments;
    if (state.state == AsyncValueState.loading) {
      return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
    }
    if (state.state == AsyncValueState.error) {
      return SliverToBoxAdapter(child: Center(child: Text('Error: ${state.error}')));
    }

    final comments = state.data ?? [];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final comment = comments[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: ListTile(
              title: Text(comment.text),
              subtitle: Text(comment.timestamp.toString().split('.').first),
            ),
          );
        },
        childCount: comments.length,
      ),
    );
  }

  Widget _buildCommentInput(ArtistDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(hintText: "Add a comment...", border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                viewModel.postComment(_commentController.text);
                _commentController.clear();
              }
            },
            icon: const Icon(Icons.send, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
