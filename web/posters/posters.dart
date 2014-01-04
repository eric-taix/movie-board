library movies;

import 'dart:html';

import 'package:polymer/polymer.dart';
 
import '../models.dart';
import '../services.dart';


@CustomTag('movie-posters')
class MoviesGridUI extends PolymerElement {
  
  List<Movie> movies = toObservable(new List());
  List<Menu> menus = toObservable(new List());
  
  @observable String searchFilter = "";
  
  MoviesGridUI.created() : super.created() {
    Menu homeMenu = new Menu(0, "All", moviesService.getAll, true);
    menus.add(homeMenu);
    menus.add(new Menu(1, "Now playing", moviesService.getNowPlaying));
    menus.add(new Menu(2, "Upcoming", moviesService.getUpcoming));
    menus.add(new Menu(3, "Top rated TV Series", moviesService.getTopRatedTVSeries));
    _applyMenu(homeMenu);
  }
  
  bool get applyAuthorStyles => true;
  
  // Applies a menu : retrieves the new list according to the menu and updates movies list
  _applyMenu(Menu menu) {
    menu.retriever().then(_updateMovies);
  }
  
  // Updates the movies list
  _updateMovies(List m) {
    movies.clear();
    movies.addAll(m);
  }
  
  // Filters movies according to the search term
  filter(String search) => (List<Movie> movies) => searchFilter.isNotEmpty ? movies.where((Movie m) => m.title.toLowerCase().contains(searchFilter.toLowerCase())).toList() : movies;
  
  // A menu has been selected
  selectMenu(Event e, var detail, Element target) {
    int menuId = int.parse(target.attributes['data-menuid']);
    if (!target.classes.contains("item-selected")) {
      target.parent.children.forEach((Element ele) => ele.classes.remove("item-selected"));
      target.classes.add("item-selected");
      _applyMenu(menus[menuId]);
    }
  }
}

