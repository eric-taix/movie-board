library movies;

import 'dart:html';

import 'package:polymer/polymer.dart';
 
import '../poster/poster.dart';
import '../models.dart';
import '../utils.dart';
import '../services.dart';


@CustomTag('movie-posters')
class MoviesGridUI extends PolymerElement {
  
  List<Movie> movies = toObservable(new List());
  List<Menu> menus = new List();
  
  MoviesGridUI.created() : super.created() {
    menus.add(new Menu(1, "Films en salle"));
    menus.add(new Menu(2, "Prochainement"));
    menus.add(new Menu(2, "Series TV"));
    moviesService.getUpcoming().then((List m) {
      movies.clear();
      movies.addAll(m);
    });
  }
  
  bool get applyAuthorStyles => true;
  
  _updateMovies(List m) {
    movies.clear();
    movies.addAll(m);
  }
  
  /**
   * Remove the current over flag except for the current one
   */
  void removeOver([Poster current = null]) {
    shadowRoot.querySelector("#movies").children.where(and([isType(Poster), notCurrent(current)])).forEach((m) => m.over = false); 
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
   * A menu has been selected
   */
  selectMenu(Event e, var detail, Element target) {
    int menuId = int.parse(target.attributes['data-menuid']);
    switch(menuId) {
      case 1 : moviesService.getNowPlaying().then(_updateMovies); break;
      case 2 : moviesService.getUpcoming().then(_updateMovies); break;
    }
  }
}

