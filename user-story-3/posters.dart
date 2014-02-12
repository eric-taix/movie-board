library movie.posters;

import 'dart:html';
import 'dart:async';

import 'package:polymer/polymer.dart';

import 'models.dart';
import 'services.dart';
import 'utils.dart';

@CustomTag('movie-posters')
class Posters extends PolymerElement {

  @observable String searchTerm = "";
  @observable String searchFilter = "";
  @observable List<Movie> movies;
  @observable String sortField;
  @observable bool sortAscending = true;

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
}