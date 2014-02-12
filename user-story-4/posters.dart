library movie.posters;

import 'dart:html';
import 'dart:async';
import 'utils.dart';

import 'package:polymer/polymer.dart';

import 'models.dart';
import 'services.dart';

@CustomTag('movie-posters')
class Posters extends PolymerElement {

  @observable String searchTerm = "";
  @observable String searchFilter = "";
  @observable List<Movie> movies;
  @observable String sortField;
  @observable bool sortAscending = true;
  bool favMenu = false;
  
  bool get applyAuthorStyles => true;

  Posters.created() : super.created() {
    moviesService.getAllMovies().then((List ms) => movies = ms);
  }
  
  filter(String term) => (List ms) => term.isEmpty ? movies : ms.where((Movie m) =>m.title.toLowerCase().contains(searchTerm)).toList();
  
  Timer _searchTimer;
  searchTermChanged(String oldValue) {
    if (_searchTimer != null) _searchTimer.cancel();
    _searchTimer = new Timer(new Duration(milliseconds: 400), () => searchFilter = searchTerm);
  }
  
  sort(Event e, var detail, Element target) {
    var field = target.dataset['field'];
    sortAscending = field == sortField ? !sortAscending : true;
    sortField = field;
    applySelected(target, 'gb');
  }
  
  sortBy(String field, bool asc) => (Iterable<Movie> ms) {
    List result = ms.toList()..sort(Movie.getComparator(field));
    return asc ? result : result.reversed;
  };
  
  _updateCategory(Future f, { favCategory : false }) {
    f.then((List<Movie> ms) => movies = ms); 
    favMenu = favCategory;
  }
  
  showCategory(Event e, var detail, Element target) {
    applySelected(target, 'item');
    switch (target.id) {
      case "all": _updateCategory(moviesService.getAllMovies()); break;
      case "playing": _updateCategory(moviesService.getMovies("now_playing")); break;
      case "upcoming": _updateCategory(moviesService.getMovies("upcoming")); break;
      case "favorite": _updateCategory(moviesService.getFavorites(), favCategory: true); break;
    }    
  }
  
  movieUpdated(Event e, Movie detail, Element target) {
    if (favMenu && !detail.favorite) movies = movies.where((Movie m) => m != detail).toList();
  }
}