library movies.detail;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

import 'services.dart';
import 'models.dart';

@CustomTag('movie-card')
class Card extends PolymerElement {
  
  @published int movieId;
  @observable MovieDetail movie;
  @observable String comment;
  @observable bool favorite;
  Card.created() : super.created();
  
  bool get applyAuthorStyles => true;
  
  /// The movie's id has changed : load it !
  movieIdChanged(int oldValue) {
    if (movieId != null) {
      moviesService.getMovieDetail(movieId).then((MovieDetail md) {
        movie = md; 
        comment = movie.comment;
        favorite = movie.favorite;
      });
    }
  }
  
  /// Utility function which generates stars
  String stars(int rating) => new List.generate(rating, (_) => "\u2605").join();
  
  /// Utility function to transform a bool to a class
  String favoriteClass(bool fav) => fav ? "favorite-selected" : "favorite";
  
  /// Flip (true <--> false) the movie's favorite attribute
  flipFavorite(Event e, var detail, Element target) => favorite = !favorite;
  
  /// Open the trailer in a new window
  openTrailer(Event e, var detail, Element target) {
    window.open("http://www.youtube.com/watch?v=${movie.trailer}", "_blank");
  }
  
  /// Save comment and favorite
  save(Event e, var detail, Element target) {
    movie.comment = comment;
    movie.favorite = favorite;
    dispatchEvent(new CustomEvent('close', detail: movie));
  }
}