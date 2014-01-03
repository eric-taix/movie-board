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
  
  @observable String title;
  @observable String searchFilter = "";
  
  MoviesGridUI.created() : super.created() {
    Menu homeMenu = new Menu(0, "All", moviesService.getAll);
    menus.add(homeMenu);
    menus.add(new Menu(1, "Now playing", moviesService.getNowPlaying));
    menus.add(new Menu(2, "Upcoming", moviesService.getUpcoming));
    menus.add(new Menu(3, "Top rated TV Series", moviesService.getTopRatedTVSeries));
    _applyMenu(homeMenu);
  }
  
  bool get applyAuthorStyles => true;
  
  _applyMenu(Menu menu) {
    title = menu.name;
    menu.retriever().then(_updateMovies);
  }
  
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
  
  filter(String search) => (List<Movie> movies) => searchFilter.isNotEmpty ? movies.where((Movie m) => m.title.toLowerCase().contains(searchFilter.toLowerCase())).toList() : movies;
  
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
    _applyMenu(menus[menuId]);
  }
}

