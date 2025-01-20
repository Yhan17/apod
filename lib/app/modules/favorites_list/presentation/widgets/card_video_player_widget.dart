import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/extensions/context_extension.dart';

class CardVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const CardVideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<CardVideoPlayerWidget> createState() => _CardVideoPlayerWidgetState();
}

class _CardVideoPlayerWidgetState extends State<CardVideoPlayerWidget> {
  late final bool _isYoutube;
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;

  late Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _initializePlayer(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant CardVideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeControllers();

      setState(() {
        _initializeFuture = _initializePlayer(widget.videoUrl);
      });
    }
  }

  Future<void> _initializePlayer(String url) async {
    final videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId != null) {
      _isYoutube = true;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
      return Future.value();
    } else {
      _isYoutube = false;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();
      _videoController!.setLooping(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: context.isLoading,
      child: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingPlaceholder();
          }

          if (snapshot.hasError) {
            return _buildErrorPlaceholder(snapshot.error);
          }

          if (_isYoutube && _youtubeController != null) {
            return YoutubePlayer(
              controller: _youtubeController!,
              showVideoProgressIndicator: true,
            );
          }

          if (!_isYoutube && _videoController != null) {
            return AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_videoController!),
                  _buildPlayPauseButton(),
                ],
              ),
            );
          }

          return _buildErrorPlaceholder('Não foi possível reproduzir o vídeo.');
        },
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return const SizedBox(
      height: 250,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorPlaceholder(Object? error) {
    return SizedBox(
      height: 250,
      child: Center(
        child: Text(
          'Erro ao inicializar o vídeo: $error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_videoController!.value.isPlaying) {
            _videoController!.pause();
          } else {
            _videoController!.play();
          }
        });
      },
      child: Container(
        color: Colors.black26,
        child: Icon(
          _videoController!.value.isPlaying
              ? Icons.pause_circle
              : Icons.play_circle,
          color: Colors.white,
          size: 64,
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_isYoutube && _youtubeController != null) {
      _youtubeController!.pause();
    } else if (!_isYoutube && _videoController != null) {
      _videoController!.pause();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _youtubeController?.dispose();
    _videoController?.dispose();
  }
}
