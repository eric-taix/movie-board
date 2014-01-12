library movies.poster;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../models.dart';

@CustomTag("movie-poster")
class Poster extends PolymerElement {
  
  @published Movie movie;
  @observable String comment;
  
  MovieStorage store;
  
  Poster.created() : super.created();
  
  movieChanged(Movie oldMovie) {
    if (movie != null) {
      store = new MovieStorage.fromLocalStorage(movie.id);
      comment = store.comment;
      bool fav = store.favorite;
      if (fav != movie.favorite) {
        flipFavorite(null, null, null);
      }
    }
  }
  
  /// Apply styles which are defined outside the component
  bool get applyAuthorStyles => true;
  
  /// Utility function which generates stars
  String stars(int rating) => new List.generate(rating, (_) => "\u2605").join();
  
  String favoriteClass(bool fav) => fav ? "liked-selected" : "liked";
  
  /// Flip (true <--> false) the movie's favorite attribute
  flipFavorite(Event e, var detail, Element target) {
    movie.favorite = !movie.favorite;
    dispatchEvent(new CustomEvent('updatefavorite', detail: movie));
    store.favorite = movie.favorite;
    store.save();
  }
  
  /// Show the detail of the current movie
  showDetail(Event e, var detail, Element target) {
    window.location.href = "#/movies/${movie.id}";
  }
}

