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

main(args) {
  File f = new File('upcoming.json');
  f.readAsString().then(JSON.decode).then((List movies) {
    movies.where(attrNotNull('poster_path')).forEach(saveImage('poster_path', 300, 'images/posters'));
    movies.where(attrNotNull('backdrop_path')).forEach(saveImage('backdrop_path', 1920, 'images/backdrops'));
  });
}