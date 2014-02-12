library movie.poster;

import 'dart:html';

import 'models.dart';
import 'package:polymer/polymer.dart';

@CustomTag('movie-poster')
class Poster extends PolymerElement {
  
  @published Movie movie = new Movie.sample();
  
  Poster.created() : super.created();
  
  bool get applyAuthorStyles => true;
  
  asStars(int nb) => new List.generate(nb, (_) => "\u2605").join();
  
  complementTo(int comp) => (nb) => comp - nb;
  
  asFavoriteClass(bool b) => b ? "favorite-selected" : "favorite";
  
  flipFavorite(Event e, var detail, Element target) => dispatchEvent(new CustomEvent("movieupdated", detail: movie ..favorite = !movie.favorite));
}