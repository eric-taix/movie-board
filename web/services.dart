library movie_board.services;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'models.dart';

final MovieService moviesService = new InMemoryMoviesService();

typedef Future<List<Movie>> MoviesRetriever(); 

/**
 * Movie service definition
 */
abstract class MovieService {
  Future<List<Movie>> getAllMovies();
  Future<List<Movie>> getFavorites();
  Future<List<Movie>> getMovies(String tag);
  Future<Movie> getMovie(int id);
  void save(Movie m);
}

/**
 * InMemory movie service implementation (for tests purpose - it does not rely on backend)
 */
class InMemoryMoviesService extends MovieService {
  
  Map<int, Movie> _allMovies = new Map();
  
  /// Retrieve all movies
  Future<Iterable<Movie>> getAllMovies() {
    if (_allMovies.isEmpty) return _getMovies('json/all.json')..then((List<Movie> m) => _allMovies = new Map.fromIterable(m, key: (Movie m) => m.id));
    else return new Future(() => _allMovies.values);
  }
  /// Retrieve favorites
  Future<Iterable<Movie>> getFavorites() => new Future(() => _allMovies.values.where((Movie m) => m.favorite).toList());
  
  /// Retrieves movies which have the specified tag
  Future<Iterable<Movie>> getMovies(String tag) => new Future(() => _allMovies.values.where((Movie m) => m.tag == tag).toList());
  
  /// Retrieve a specific movie from its ID
  Future<Movie> getMovie(int id) => new Future(() => _allMovies[id]);
  
  /// Save a movie
  void save(Movie m) { }
  

  // Internal method to retrieve movies from a json url (also works without server - only dartium)
  Future<List<Movie>> _getMovies(String jsonUrl) {
    Completer completer = new Completer();
    HttpRequest.getString(jsonUrl).then(JSON.decode).then((List jsonMovies) {
      List<Movie> movies = jsonMovies.map((Map map) => new Movie.fromMap(map)).toList();
      completer.complete(movies);
    });
    return completer.future;
  }
}
