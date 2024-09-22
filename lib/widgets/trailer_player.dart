import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie.dart';

class TrailerPlayer extends StatefulWidget {
  final Movie movie;

  TrailerPlayer({required this.movie});

  @override
  _TrailerPlayerState createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  YoutubePlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.movie.trailerUrl != null && widget.movie.trailerUrl!.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.movie.trailerUrl!,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: false,
        ),
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return _buildErrorWidget('No trailer available');
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: CupertinoColors.activeBlue,
        progressColors: ProgressBarColors(
          playedColor: CupertinoColors.activeBlue,
          handleColor: CupertinoColors.activeBlue,
        ),
      ),
      builder: (context, player) {
        return Stack(
          fit: StackFit.expand,
          children: [
            player,
            _buildMovieInfo(),
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: Text(message, style: TextStyle(color: CupertinoColors.white))),
        _buildMovieInfo(),
      ],
    );
  }

  Widget _buildMovieInfo() {
    return Positioned(
      left: 10,
      bottom: 20,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.movie.title,
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.movie.overview,
            style: TextStyle(color: CupertinoColors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}