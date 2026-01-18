import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tentwenty_assignment/core/utils/snackbar_utils.dart';
import 'package:tentwenty_assignment/presentation/providers/movie_list_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:collection/collection.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final int movieId;

  const VideoPlayerScreen({super.key, required this.movieId});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _lockLandscape();
    _fetchAndInitVideo();
  }

  void _lockLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _fetchAndInitVideo() async {
    try {
      final videos = await ref.read(movieVideosProvider(widget.movieId).future);

      if (videos.isEmpty) {
        SnackbarUtils.showMessage(
          context,
          'No videos available for this movie',
        );
        _closePlayer();
        return;
      }

      final trailer = videos.firstWhereOrNull(
        (v) => v.site == 'YouTube' && v.type == 'Trailer',
      );

      if (trailer == null) {
        SnackbarUtils.showMessage(context, 'No YouTube trailer available');
        _closePlayer();
        return;
      }

      _controller = YoutubePlayerController(
        initialVideoId: trailer.key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: true,
          hideControls: false,
          forceHD: true,
        ),
      )..addListener(_videoListener);
    } catch (e) {
      SnackbarUtils.showError(context, 'Failed to load videos');
      _closePlayer();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _videoListener() {
    if (_controller?.value.playerState == PlayerState.ended) {
      _closePlayer();
    }
  }

  void _closePlayer() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_controller != null)
              YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
              )
            else
              const Center(
                child: Text(
                  'Trailer not available',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _closePlayer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
