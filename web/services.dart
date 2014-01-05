library movie_board.services;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'models.dart';

final moviesService = new InMemoryMoviesService();

typedef Future<List<Movie>> MoviesRetriever(); 

class InMemoryMoviesService {
  
  List<Movie> _favorites = new List();
  
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
  
  // Add a movie to favorites
  updateFavorite(Movie m) => m.favorite ? _favorites.add(m) : _favorites.remove(m);
  
  // Returns the favorites list
  Future<List<Movie>> getFavorites()  {
    Completer completer = new Completer();
    completer.complete(_favorites);
    return completer.future;
  }
  
  Future<List<Movie>> _getMovies(String jsonUrl) {
    Completer completer = new Completer();
    HttpRequest.getString(jsonUrl).then(JSON.decode).then((List l) {
      List<Movie> movies = l.map((Map map) => new Movie.fromMap(map)).toList();
      completer.complete(movies);
    });
    return completer.future;
  }
}
