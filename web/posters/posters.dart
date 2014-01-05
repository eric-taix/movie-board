library movies;

import 'dart:html';

import 'package:polymer/polymer.dart';
 
import '../models.dart';
import '../services.dart';


@CustomTag('movie-posters')
class MoviesGridUI extends PolymerElement {
  
  List<Movie> movies = toObservable(new List());
  List<Menu> menus = new List();
  Menu _currentMenu;
  
  @observable String searchFilter = "";
  
  MoviesGridUI.created() : super.created() {
    Menu homeMenu = new Menu(0, "All", moviesService.getAll, true);
    menus.add(homeMenu);
    menus.add(new Menu(1, "Now playing", moviesService.getNowPlaying));
    menus.add(new Menu(2, "Upcoming", moviesService.getUpcoming));
    menus.add(new Menu(3, "Top rated TV Series", moviesService.getTopRatedTVSeries));
    menus.add(new Menu(4, "Favorites", moviesService.getFavorites));
    _applyMenu(homeMenu);
  }
  
  bool get applyAuthorStyles => true;
  
  // Applies a menu : retrieves the new list according to the menu and updates movies list
  _applyMenu(Menu menu) {
    menu.retriever().then(_updateMovies);
    _currentMenu = menu;
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
  
  updateFavorite(Event e, Movie detail, Element target) {
    moviesService.updateFavorite(detail);
    // In case the current menu is favorite, then remove the movie if it is not more a favorite
    if (_currentMenu != null && _currentMenu.id == 4 && !detail.favorite) movies.remove(detail);
  }
}

