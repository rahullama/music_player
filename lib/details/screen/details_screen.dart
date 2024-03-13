import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';

class DetailScreen extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String artist;
  final String heroTag;

  const DetailScreen({
    required this.imageUrl,
    required this.name,
    required this.artist,
    required this.heroTag,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  bool audioPlayed = false;
  final audioPlayer = AudioPlayer();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    audioPlayer.stop();
  }

  Future<void> playAudioFromUrl(String url) async {
    await audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.heroTag,
            child: Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7), // Adjust opacity as needed
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.artist,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      if(audioPlayed == false){
                        playAudioFromUrl("https://filesamples.com/samples/audio/mp3/Symphony%20No.6%20(1st%20movement).mp3");
                        audioPlayed = true;
                      } else {
                        audioPlayer.stop();
                        audioPlayed = false;
                      }
                      setState((){});
                    },
                    icon: Icon(audioPlayed?Icons.pause:Icons.play_arrow),
                    label: const Text('Play'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      )
    );
  }
}