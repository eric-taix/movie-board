library movie_board.services;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'models.dart';

final moviesService = new InMemoryMoviesService();

class InMemoryMoviesService {
  
  Future<List<Movie>> getNowPlaying() => _getMovies('json/now_playing.json');
  
  Future<List<Movie>> getUpcoming() => _getMovies('json/upcoming.json');
  
  Future<List<Movie>> _getMovies(String jsonUrl) {
    Completer completer = new Completer();
    HttpRequest.getString(jsonUrl).then(JSON.decode).then((List l) {
      List<Movie> movies = l.map((Map map) => new Movie.fromMap(map)).toList();
      completer.complete(movies);
    });
    return completer.future;
  }
}
