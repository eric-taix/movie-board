import 'package:polymer/polymer.dart';
import 'dart:html';
import '../services.dart';
import '../models.dart';

@CustomTag('j-genresmenu')
class GenresMenuUI extends PolymerElement {
  
  List<Genre> _genres = toObservable(new List());

  GenresMenuUI.created() : super.created() {
    MockGenreService service = new MockGenreService();
    service.getGenres().then((List<Genre> g) {
      genres.clear();
      genres.addAll(g);
    });
  }
  
  List<Genre> get genres => _genres;
  
  selectGenre(Event e, var detail, Element target) {
    // target.classes.add("highlighted");
    dispatchEvent(new CustomEvent('filterbygenre', detail: target.attributes['data-genreid']));
  }
}