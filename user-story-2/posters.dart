library movie.posters;

import 'package:polymer/polymer.dart';

import 'models.dart';
import 'services.dart';


@CustomTag('movie-posters')
class Posters extends PolymerElement {

  @observable List<Movie> movies;

  bool get applyAuthorStyles => true;

  Posters.created() : super.created() {
    moviesService.getAllMovies().then((List ms) => movies = ms);
  }
}