library movie_board.services;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'models.dart';

final moviesService = new InMemoryMoviesService();

typedef Future<List<Movie>> MoviesRetriever(); 

class InMemoryMoviesService {
  
  Future<List<Movie>> getAll() {
    Completer completer = new Completer();
    Future.wait([getNowPlaying(), getUpcoming(), getTopRatedTVSeries()]).then((List<List<Movie>> r) {
      List<Movie> result = r.reduce((List<Movie> list1, List<Movie> list2) => list1..addAll(list2));
      completer.complete(result);
    });
    return completer.future;
  }
  
  Future<List<Movie>> getNowPlaying() => _getMovies('json/now_playing.json');
  
  Future<List<Movie>> getUpcoming() => _getMovies('json/upcoming.json');
  
  Future<List<Movie>> getTopRatedTVSeries() => _getMovies('json/tv_top_rated.json');
  
  Future<List<Movie>> _getMovies(String jsonUrl) {
    Completer completer = new Completer();
    HttpRequest.getString(jsonUrl).then(JSON.decode).then((List l) {
      List<Movie> movies = l.map((Map map) => new Movie.fromMap(map)).toList();
      completer.complete(movies);
    });
    return completer.future;
  }
}
