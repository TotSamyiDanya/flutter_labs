import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:player/audio.dart';
import 'package:player/parser.dart';
import 'package:player/widgets.dart';
import 'models.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  AlbumsParser parser = AlbumsParser();
  List<Album> albums = [];
  List<Song> songs = [];
  List<Widget> albumsSliders = [];
  int currentAlbum = 0;
  int highlightSong = 0;
  final GlobalKey<MyAudioPlayerState> _audioPlayerKey = GlobalKey();
  bool playerIsReady = false;

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }
  void fetchAlbums() async {
    var data = await parser.fetchAlbums();
    setState(() {
      albums = data;
      songs = data[currentAlbum].songs;
      albumsSliders = getAlbumsSliders(data);
      playerIsReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         const Divider(
             height: 10,
             color: Colors.transparent
         ),
         SizedBox(
           height: 170,
           child: CarouselSlider(
             options: CarouselOptions(
               autoPlay: false,
               aspectRatio: 2.0,
               enlargeCenterPage: true,
               onPageChanged: (index, reason) {
                 currentAlbum = index;
                 setState(() {
                   songs = albums[currentAlbum].songs;
                 });
               }
             ),
             items: albumsSliders,
           ),
         ),
         const Divider(
             height: 10,
             color: Colors.transparent
         ),
         SizedBox(
             height: 315,
             child: ListView.separated(
                 padding: const EdgeInsets.only(left: 15.0, top: 8.0, right: 15.0, bottom: 8.0),
                 itemCount: songs.length,
                 scrollDirection: Axis.vertical,
                 itemBuilder: (BuildContext context, int index) {
                   return getSongCard(albums[currentAlbum], songs[index], () => { _audioPlayerKey.currentState!.changeAudioTap(index) });
                 },
                 separatorBuilder: (BuildContext context, int index) {
                   return const Divider(height: 15, color: Colors.transparent);
                 }
             )
         ),
         const Divider(
             height: 10,
             color: Colors.transparent
         ),
         SizedBox(
           height: 140,
           child: playerIsReady ? MyAudioPlayer(key: _audioPlayerKey, album: albums[currentAlbum]) : const Divider(),
         )
       ],
     )
    );
  }
}