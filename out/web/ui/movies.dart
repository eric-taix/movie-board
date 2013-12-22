import 'dart:html';
import 'package:polymer/polymer.dart';
import '../models.dart';
import '../services.dart';
import 'movie.dart';

@CustomTag('j-movies')
class MoviesGridUI extends PolymerElement {
  
  List<Movie> movies = toObservable(moviesService.movies);
  
  MoviesGridUI.created() : super.created();
  
  /**
   * The mouse is over a poster
   */
  posterOver(Event e, var detail, Node target) {
    shadowRoot.children.where((m) => m is MoviePosterUI).where((m) => m != detail).forEach((m) {
      m.over = false; 
    });
  }
  
  /**
   * The mouse is out of the grid
   */
  postersOut(Event e, var detail, Node target) {
    dispatchEvent(new CustomEvent('posterover', detail: this));
  }
  
  /**
   * Filter movies by genre
   */
  filterByGenre(Event e, var detail, Node target) {
    print(detail);
  }
}
