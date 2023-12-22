import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:player/widgets.dart';
import 'models.dart';

class MyAudioPlayer extends StatefulWidget {
  MyAudioPlayer({super.key, this.album});

  Album? album;

  @override
  MyAudioPlayerState createState() => MyAudioPlayerState();
}

class MyAudioPlayerState extends State<MyAudioPlayer> {
  final key = GlobalKey();
  AudioPlayer audioPlayer = AudioPlayer();
  int currentSong = 0;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = parseDuration(widget.album!.songs[currentSong].duration);
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future<void> setAudio() async {
    audioPlayer.setSourceUrl("http://10.0.2.2:5067/api/songs/${widget.album!.title}/${widget.album!.songs[currentSong].title}.mp3");
  }

  Future<void> changeAudio() async {
    setState(() {

    });
    await audioPlayer.stop();
    await audioPlayer.play(UrlSource("http://10.0.2.2:5067/api/songs/${widget.album!.title}/${widget.album!.songs[currentSong].title}.mp3"));
  }

  Future<void> changeAudioTap(int songNumber) async {
    setState(() {
      currentSong = songNumber;
    });
    await audioPlayer.play(UrlSource("http://10.0.2.2:5067/api/songs/${widget.album!.title}/${widget.album!.songs[currentSong].title}.mp3"));
  }

  void changeAlbum(Album album) {
    setState(() {
      widget.album = album;
      currentSong = 0;
      changeAudio();
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
                    child: Text(
                      "${widget.album!.author} - ${parseSongTitle(widget.album!.songs[currentSong].title)}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
                await audioPlayer.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration - position))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        currentSong = (currentSong - 1) % widget.album!.songs.length;
                        changeAudio();
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    child: IconButton(
                      icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow
                      ),
                      iconSize: 30,
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        }
                        else {
                          await audioPlayer.play(UrlSource("http://10.0.2.2:5067/api/songs/${widget.album!.title}/${widget.album!.songs[currentSong].title}.mp3"));
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        currentSong = (currentSong + 1) % widget.album!.songs.length;
                        changeAudio();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds
  ].join(':');
}
Duration parseDuration(String duration) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = duration.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

class MyEvent {
  final int index;
  MyEvent(this.index);
}