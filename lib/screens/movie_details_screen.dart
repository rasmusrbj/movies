import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.movie.videos.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.movie.videos.first.key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.64,
                  width: double.infinity,
                ),
                Positioned(
                  top: 64,
                  left: 16,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(12),
                    color: CupertinoColors.darkBackgroundGray.withOpacity(0.64),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: CupertinoColors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Released: ',
                            style: TextStyle(
                                fontSize: 16,
                                color: CupertinoColors.systemGrey),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatReleaseDate(widget.movie.releaseDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rating: ${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                        style: const TextStyle(
                            fontSize: 16, color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        'Share',
                        icon: CupertinoIcons.share,
                        color: CupertinoColors.systemGrey6,
                        onPressed: () {},
                      ),
                      _buildActionButton(
                        'Like',
                        icon: CupertinoIcons.heart,
                        color: CupertinoColors.systemGrey6,
                        onPressed: () {},
                      ),
                      _buildActionButton(
                        'Save',
                        icon: CupertinoIcons.bookmark,
                        color: CupertinoColors.systemGrey6,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      const Text(
                        'Overview',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          widget.movie.overview,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: CupertinoColors.darkBackgroundGray),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Genres',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.movie.genres
                              .map((genre) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey5,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(genre, style: TextStyle(color: CupertinoColors.darkBackgroundGray, fontSize: 16),),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Trailer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_controller != null)
                    YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                    )
                  else
                    Container(),
                  SafeArea(child: Container()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        CupertinoButton(
          onPressed: onPressed,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                Icon(icon, size: 30, color: CupertinoColors.darkBackgroundGray),
          ),
        ),
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
          ),
        ],
      ],
    );
  }

  String _formatReleaseDate(String? releaseDate) {
    if (releaseDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return DateFormat.yMMMMd().format(date); // e.g., "July 10, 2023"
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
