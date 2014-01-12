import 'dart:io';
import 'dart:convert';

attrNotNull(String attr) => (e) => e[attr] != null;

saveImage(String imgAttrName, int imageWidth, [String imagePath = 'images']) => (Map json) {
  new HttpClient().getUrl(Uri.parse('http://image.tmdb.org/t/p/w${imageWidth}${json[imgAttrName]}'))
    .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) => response.pipe(new File('${imagePath}${json[imgAttrName]}').openWrite()), onError: (e) {
        print(e);
      });
};

getImages(File f) {
  f.readAsString().then(JSON.decode).then((List movies) {
    movies.where(attrNotNull('poster_path')).forEach(saveImage('poster_path', 342, 'images/posters'));
   // movies.where(attrNotNull('backdrop_path')).forEach(saveImage('backdrop_path', 780, 'images/backdrops'));
  });
}

saveAllMoviesJSON(String file, String apiKey) {
  new File(file).readAsString().then(JSON.decode).then((List movies) => movies.forEach((Map movie) {
    String baseApi = movie['tag'] == 'tv_top_rated' ? 'tv' : 'movie';
    saveMovieJSON(movie['id'], movie['poster_path'], apiKey); 
  }));
}

saveMovieJSON(int movieId, String posterPath, String apiKey, {String baseApi : 'movie'}) {
  new HttpClient().getUrl(Uri.parse('http://api.themoviedb.org/3/${baseApi}/${movieId}?api_key=${apiKey}&append_to_response=trailers'))
    .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) {
        response.transform(UTF8.decoder).toList().then((data) {
          Map map = JSON.decode(data.join(''))..['poster_path'] = posterPath;
          String result = JSON.encode(map);
          File f = new File('movies/${movieId}.json');
          f.writeAsString(result);
        });
      });
}

main(args) {
//  getImages(new File('now_playing.json'));
//  getImages(new File('upcoming.json'));
//  getImages(new File('tv_top_rated.json'));
//  saveMovieJSON(550);
  saveAllMoviesJSON('all.json','');
}