import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'models.dart';

List<Widget> getAlbumsSliders(List<Album> albums) {
  return albums.map((album) =>
      Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(album.cover, fit: BoxFit.cover, width: 1000.0, height: 200,),
                Positioned(bottom: 0.0, left: 0.0, right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      '${album.author} - ${album.title}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      )).toList();
}
Widget getSongCard(Album album, Song song, VoidCallback onTapCallback) {
  return Container(
    height: 65,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(5),
      shape: BoxShape.rectangle
    ),
    child: GestureDetector(
      onTap: onTapCallback,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(album.cover, width: 55, height: 55),
                ),
              )
            ],
          ),
          Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                             child: Padding(
                                 padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                 child: Text(
                                   parseSongTitle(song.title),
                                   overflow: TextOverflow.ellipsis,
                                   maxLines: 1,
                                   style: const TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.bold
                                   ),
                                 )
                             )
                         )
                        ]
                    ),
                  ),
                  Expanded(
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 10),
                                child: Text(
                                  album.author,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal
                                  ),)
                            )
                          ]
                      )
                  )
                ],
              )
          ),
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                child: Text(song.duration))
              ]
          )
        ],
      )
    )
  );
}

String parseSongTitle(String title) {
  String result = title.replaceAll('-', ' ');
  return "${result[0].toUpperCase()}${result.substring(1).toLowerCase()}";
}