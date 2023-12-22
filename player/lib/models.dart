class Album {
  final String title;
  final String author;
  final String cover;
  final List<Song> songs;

  const Album({
    required this.title,
    required this.author,
    required this.cover,
    required this.songs
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    var songsList = json['songs'] as List<dynamic>;
    var songs = songsList.map((songJson) => Song.fromJson(songJson)).toList();

    return Album(title: json['title'], author: json['author'], cover: json['cover'], songs: songs);
  }
}
class Song {
  final String title;
  final String duration;

  const Song({
    required this.title,
    required this.duration
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(title: json['title'], duration: json['duration']);
  }
}