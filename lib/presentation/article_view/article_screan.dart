import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ArticleScrean extends StatefulWidget {
  final String image;
  final String title;
  final String author;
  final String date;
  final String brief;
  final String url;

  const ArticleScrean({
    super.key,
    required this.image,
    required this.title,
    required this.author,
    required this.date,
    required this.brief,
    required this.url,
  });

  @override
  State<ArticleScrean> createState() => _ArticleScreanState();
}

class _ArticleScreanState extends State<ArticleScrean> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('News', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.brief,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Text(
                widget.author,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                widget.date,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                    alignment: AlignmentDirectional.center,
                    children:[
                      Image.network(
                        widget.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                              ),
                            ),
                          );
                        },
                        icon: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Icon(Icons.videocam, color: Colors.red),
                        ),
                      )
                    ]
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.brief,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
