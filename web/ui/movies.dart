library movies.ui;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import '../models.dart';
import '../service/services.dart';
import 'movie.dart';
import '../utils.dart';

@CustomTag('j-movies')
class MoviesGridUI extends PolymerElement {
  
  List<Movie> movies = toObservable(new List());
  List<Genre> _genres = toObservable(new List());
  
  MoviesGridUI.created() : super.created() {
    MockGenreService service = new MockGenreService();
    service.getGenres().then((List<Genre> g) {
      _genres.clear();
      _genres.addAll(g);
      _genres.insert(0, new Genre(-1, "Films en salle"));
      moviesService.getNowPlaying().then((List m) {
        movies.clear();
        movies.addAll(m);
      });
    });
    movies.clear();
  }
  
  bool get applyAuthorStyles => true;
  
  List<Genre> get genres => _genres;
  
  /**
   * Remove the current over flag except for the current one
   */
  void removeOver([MoviePosterUI current = null]) {
    shadowRoot.querySelector("#movies").children.where(and([isType(MoviePosterUI), notCurrent(current)])).forEach((m) => m.over = false); 
  }
  
  //--------- Events handling ------------
  /**
   * The mouse is over a poster
   */
  posterOver(Event e, var detail, Node target) {
    removeOver(detail);
  }
  
  /**
   * The mouse is out of the grid
   */
  postersOut(Event e, var detail, Node target) {
    removeOver();
  }
  
  /**
   * Filter movies by genre
   */
  selectGenre(Event e, var detail, Element target) {
    int genreId = int.parse(target.attributes['data-genreid']);
//    movies.clear();
//    movies.addAll(_allMovies.where((m) => m.genre == genreId || genreId == -1));
  }
}
