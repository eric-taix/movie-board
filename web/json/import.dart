import 'dart:io';
import 'dart:convert';

attrNotNull(String attr) => (e) => e[attr] != null;

main(args) {
 
  File f = new File('now_playing.json');
  f.readAsString().then(JSON.decode).then((List movies) {
    movies.where(attrNotNull('poster_path')).forEach((Map json) {
      new HttpClient().getUrl(Uri.parse('http://image.tmdb.org/t/p/w300${json['poster_path']}'))
        .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) => 
              response.pipe(new File('images${json['poster_path']}').openWrite()));
    });
  });
}