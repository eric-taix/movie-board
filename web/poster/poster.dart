library movie_board.movie_poster;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../models.dart';

@CustomTag("movie-poster")
class Poster extends PolymerElement {
  
  @published Movie movie;
  
  Poster.created() : super.created();
  
  /// Apply styles which are defined outside the component
  bool get applyAuthorStyles => true;
  
  /// Utility function which generates stars
  String stars(int rating) => new List.generate(rating, (_) => "\u2605").join();
  
  String favoriteClass(bool fav) => fav ? "liked-selected" : "liked";
  
  /// Flip (true <--> false) the movie's favorite attribute
  flipFavorite(Event e, var detail, Element target) {
    movie.favorite = !movie.favorite;
    dispatchEvent(new CustomEvent('updatefavorite', detail: movie));
  }
}

