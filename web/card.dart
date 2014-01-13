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
  
  Card.created() : super.created();
  
  bool get applyAuthorStyles => true;
  
  movieIdChanged(int oldValue) {
    if (movieId != null) {
      moviesService.getMovieDetail(movieId).then((MovieDetail md) {
        movie = md; 
        comment = new MovieStorage.fromLocalStorage(movieId).comment;
      });
    }
  }
  
  /// Utility function which generates stars
  String stars(int rating) => new List.generate(rating, (_) => "\u2605").join();
  
  /// Open the trailer in a new window
  openTrailer(Event e, var detail, Element target) {
    window.open("http://www.youtube.com/watch?v=${movie.trailer}", "_blank");
  }
  
  /// Save a comment into the local storage
  saveComment(Event e, var detail, Element target) {
    MovieStorage store = new MovieStorage.fromLocalStorage(movie.id);
    store.comment = comment;
    store.save();
    dispatchEvent(new CustomEvent('close'));
  }
}