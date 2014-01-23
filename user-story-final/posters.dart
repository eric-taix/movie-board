library movies.posters;

import 'dart:html';
import 'dart:async';

import 'package:polymer/polymer.dart';
 
import 'models.dart';
import 'services.dart';
import 'utils.dart';


@CustomTag('movie-posters')
class Posters extends PolymerElement {
  
  @observable Iterable<Movie> movies = toObservable(new List());
  @observable String sortField = "";
  @observable bool sortAscending = true;
  @observable bool hasMovies = false;
  
  List<Menu> menus = new List();
  Menu _currentMenu;
  
  @observable String searchFilter = "";
  @observable String searchTerm = "";
  
  Posters.created() : super.created() {
    Menu homeMenu = new Menu(0, "All", moviesService.getAllMovies, true);
    menus..add(homeMenu)
          ..add(new Menu(1, "Now playing", () => moviesService.getMovies("now_playing")))
          ..add(new Menu(2, "Upcoming", () => moviesService.getMovies("upcoming")))
          ..add(new Menu(3, "Favorites", () => moviesService.getFavorites()));
    _applyMenu(homeMenu);
  }
  
  bool get applyAuthorStyles => true;
  
  /// Applies a menu : retrieves the new list according to the menu and updates movies list
  _applyMenu(Menu menu) => _currentMenu = menu ..retriever().then((Iterable<Movie> m) => _updateMovies(m));
  
  /// The search term has been changed (automatically called when the observable searchTerm is modified)
  searchTermChanged(String oldValue) => applyDelayed(400, () => searchFilter = searchTerm);
  
  /// Filters movies according to the search term
  filter(String search) => (Iterable<Movie> movies) => searchFilter.isNotEmpty ? movies.where((Movie m) => m.title.toLowerCase().contains(searchFilter.toLowerCase())).toList() : movies;
    
  /// Sort according to a field's name : if this field is already the current sorting field then reverse the sort
  sortBy(String field, bool ascending) => (Iterable games) {
    var list = games.toList()..sort(Movie.getComparator(field));
    return ascending ? list : list.reversed;
  };
  
  /// A menu has been selected
  selectMenu(Event e, var detail, Element target) {
    int menuId = int.parse(target.dataset['menuid']);
    if (applySelectedCSS(target, "item")) {
      _applyMenu(menus[menuId]);
    }
  }
  
  /// A movie's favorite attribute has been modified
  updateFavorite(Event e, Movie detail, Element target) {
    moviesService.save(detail);
    // In case the current menu is favorite, then remove the movie if it's not more a favorite
    if (_currentMenu != null && _currentMenu.id == 4 && !detail.favorite) _updateMovies(movies.where((Movie m) => m != detail).toList());
  }
  
  /// A sort button has been clicked
  sort(Event e, var detail, Element target) {
    var field = target.dataset['field'];
    sortAscending = field == sortField ? !sortAscending : true;
    sortField = field;
    applySelectedCSS(target, "gb");
  }
  
  /// A movie has been modified: reflect the change into the current list
  movieModified(Movie md) {
    Movie m = movies.firstWhere((Movie m) => m.id == md.id);
    if (m != null) {
      m.favorite = md.favorite;
      m.comment = md.comment;
    }
  }
  _updateMovies(Iterable<Movie> newMovies) {
    movies = newMovies;
    hasMovies = movies.isNotEmpty;
  }
}

