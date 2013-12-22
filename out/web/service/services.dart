library movies.services;

import 'dart:convert';
import 'dart:html';
import 'dart:async';

import '../models.dart';

final moviesService = new InMemoryMoviesService();

class InMemoryMoviesService {
  final List<Movie> movies = [
     new Movie('Belle et Sébastien', 'img/bes.jpg')..genre=12,
     new Movie('Le Hobbit', 'img/lh.jpg', featured: false)..genre=28,
     new Movie('Hunger games', 'img/hgl.jpg')..genre=28,
     new Movie('A touch of Sin', 'img/atos.jpg')..genre=16,
     new Movie('All is lost', 'img/allislost.jpg')..genre=28,
     new Movie('Henri', 'img/henri.jpg')..genre=35,
     new Movie('Immigrant', 'img/immigrant.jpg')..genre=35,
     new Movie('Last vegas', 'img/lastvegas.jpg')..genre=28,
     new Movie("Rêves d'or", 'img/revesdor.jpg')..genre=28,
     new Movie('Sur la terre des dinosaures', 'img/surlaterredesdinosaures.jpg')..genre=16,  
     new Movie('Suzanne', 'img/suzanne.jpg')..genre=35,     
     new Movie('The lunch box', 'img/thelunchbox.jpg')..genre=35,     
     new Movie('Zulu', 'img/zulu.jpg')..genre=35,          
  ];
}

class MockGenreService {
    
  Future<List<Genre>> getGenres() {
    Completer completer = new Completer();
    HttpRequest.getString('json/genre/list.json').then(JSON.decode).then((List l) {
      List<Genre> genres = l.map((Map map) => new Genre.fromMap(map)).toList();
      completer.complete(genres);
    });
    return completer.future;
  }
  
}
