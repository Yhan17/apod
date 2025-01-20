import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CardVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const CardVideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<CardVideoPlayerWidget> createState() => _CardVideoPlayerWidgetState();
}

class _CardVideoPlayerWidgetState extends State<CardVideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late YoutubePlayerController _youtubeController;

  bool _isYoutube = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null) {
      _isYoutube = true;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );

      setState(() {
        _isInitialized = true;
      });
    } else {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      try {
        await _videoController.initialize();
        _videoController.setLooping(false);
        setState(() {
          _isInitialized = true;
        });
      } catch (e) {
        debugPrint('Erro ao inicializar vídeo: $e');
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isYoutube) {
      return YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
      );
    }

    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_videoController),
          _buildPlayPauseButton(),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_videoController.value.isPlaying) {
            _videoController.pause();
          } else {
            _videoController.play();
          }
        });
      },
      child: Container(
        color: Colors.black26,
        child: Icon(
          _videoController.value.isPlaying
              ? Icons.pause_circle
              : Icons.play_circle,
          color: Colors.white,
          size: 64,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isYoutube) {
      _youtubeController.dispose();
    } else {
      _videoController.dispose();
    }
    super.dispose();
  }
}
