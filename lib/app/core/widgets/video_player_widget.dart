import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../extensions/context_extension.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final bool _isYoutube;
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;

  late final Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _initializePlayer(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
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
        flags: const YoutubePlayerFlags(loop: true),
      );

      return Future.value();
    } else {
      _isYoutube = false;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();
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
            return const SizedBox(
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            );
          }
      
          if (snapshot.hasError) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Text(
                  'Erro ao inicializar o vídeo: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
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
              child: VideoPlayer(_videoController!),
            );
          }
      
          return const SizedBox(
            height: 250,
            child: Center(child: Text('Não foi possível reproduzir o vídeo.')),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
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

  void _disposeControllers() {
    _youtubeController?.dispose();
    _videoController?.dispose();
  }
}
