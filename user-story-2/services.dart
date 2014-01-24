library movie.services;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'models.dart';

abstract class MovieService {
  
  Future<List<Movie>> getAllMovies();
  
}

class InMemoryMovieService implements MovieService {
  
  List<Movie> _movies;
  
  Future<List<Movie>> getAllMovies() {
    if (_movies == null) return _getMovies('json/all.json')..then((List<Movie> m) => _movies = m);
    else return new Future(() => _movies);
  }
  
  Future<List<Movie>> _getMovies(String jsonUrl) {
    Completer completer = new Completer();
    HttpRequest.getString(jsonUrl).then(JSON.decode).then((List<Map> jsonMovies) {
      List<Movie> movies = jsonMovies.map((Map map) => new Movie.fromJSON(map)).toList();
      completer.complete(movies);
    });
    return completer.future;
  }
}