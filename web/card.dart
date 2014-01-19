library movies.detail;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

import 'services.dart';
import 'models.dart';
import 'utils.dart';

@CustomTag('movie-card')
class Card extends PolymerElement {
  
  @published int movieId;
  @observable MovieDetail movie;
  // Note: comment and favorite values are extracted from [MovieDetail] because we don't want to store 
  // new values before the user clicks the "Save" button. Therefore the view is binded to the attributes below and not 
  // directly to the business model
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
  
  /// Filter to generate stars
  Function asStars = intToStars();
  /// Filter to generate the selected class
  Function asFavoriteClass = selectedToClass('favorite');

  /// Flip (true <--> false) the movie's favorite attribute
  flipFavorite(Event e, var detail, Element target) => favorite = !favorite;
  
  /// Open the trailer in a new window
  openTrailer(Event e, var detail, Element target) => window.open("http://www.youtube.com/watch?v=${movie.trailer}", "_blank");
  
  /// Save comment and favorite
  save(Event e, var detail, Element target) => dispatchEvent(new CustomEvent('close', detail: movie ..comment=comment ..favorite=favorite));
}


