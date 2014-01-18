library movies.poster;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'models.dart';

@CustomTag("movie-poster")
class Poster extends PolymerElement {
  
  @published Movie movie;
  @observable String comment;
  
  Poster.created() : super.created();
  
  /// The movie attribut has changed
  movieChanged(Movie oldMovie) {
  }
  
  /// Apply styles which are defined outside the component
  bool get applyAuthorStyles => true;
  
  /// Utility function which generates stars
  String stars(int rating) => new List.generate(rating, (_) => "\u2605").join();
  
  /// Utility function to transform a bool to a class
  String favoriteClass(bool fav) => fav ? "liked-selected" : "liked";
  
  /// Flip (true <--> false) the movie's favorite attribute
  flipFavorite(Event e, var detail, Element target) {
    movie.favorite = !movie.favorite;
    dispatchEvent(new CustomEvent('updatefavorite', detail: movie));
  }
  
  /// Show the detail of the current movie
  showDetail(Event e, var detail, Element target) {
    window.location.href = "#/movies/${movie.id}";
  }
}

