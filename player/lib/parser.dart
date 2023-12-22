import 'dart:io';
import 'dart:convert';
import 'models.dart';

class AlbumsParser {
  Future<List<Album>> fetchAlbums() async {
    List<Album> result = [];

    var client = HttpClient();
    var request = await client.getUrl(Uri.parse('https://10.0.2.2:7083/api/albums'));
    var response = await request.close();

    if (response.statusCode == 200) {
      var albums = jsonDecode(await response.transform(utf8.decoder).join()) as List<dynamic>;
      result = albums.map((json) => Album.fromJson(json)).toList();
    }
    else {
      throw Exception('Fetch error');
    }

    return result;
  }
}