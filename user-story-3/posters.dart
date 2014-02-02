library movie.posters;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'models.dart';
import 'services.dart';
import 'utils.dart';

@CustomTag('movie-posters')
class Posters extends PolymerElement {
  
  @observable List<Movie> movies;
  @observable String searchTerm = '';
  @observable String searchFilter = '';
  @observable String sortField;
  @observable bool sortAscending = true;
  
  bool get applyAuthorStyles => true;
  
  Posters.created() : super.created() {
    moviesService.getAllMovies().then((List ms) => movies = ms);
  }
  
  filter(String term) => (List<Movie> m) => term.isNotEmpty ? m.where((Movie m) => m.title.toLowerCase().contains(searchTerm.toLowerCase())) : m;
  
  Timer timer;
  searchTermChanged(String oldValue) {
    if (timer != null && timer.isActive) timer.cancel();
    timer = new Timer(new Duration(milliseconds: 400), () => searchFilter = searchTerm);
  }
  
  sortBy(String field, bool asc) => (Iterable<Movie> ms) {
    List result = ms.toList()..sort(Movie.getComparator(field));
    return asc ? result : result.reversed;
  };
  
  sort(Event e, var detail, Element target) {
    var field = target.dataset['field'];
    sortAscending = field == sortField ? !sortAscending : true;
    sortField = field;
    applySelectedCSS(target, "gb");
  } 
}
