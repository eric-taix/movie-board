library movies.services;

import 'dart:convert';
import 'dart:html';
import 'dart:async';

import '../models.dart';

final moviesService = new InMemoryMoviesService();

class InMemoryMoviesService {
  final List<Movie> movies = [
     new Movie('Belle et Sébastien', 'img/bes.jpg'),
     new Movie('Le Hobbit', 'img/lh.jpg', featured: false),
     new Movie('Hunger games', 'img/hgl.jpg'),
     new Movie('A touch of Sin', 'img/atos.jpg'),
     new Movie('A touch of Sin', 'img/allislost.jpg'),
     new Movie('Henri', 'img/henri.jpg'),
     new Movie('Immigrant', 'img/immigrant.jpg'),
     new Movie('Last vegas', 'img/lastvegas.jpg'),
     new Movie("Rêves d'or", 'img/revesdor.jpg'),
     new Movie('Sur la terre des dinosaures', 'img/surlaterredesdinosaures.jpg'),  
     new Movie('Suzanne', 'img/suzanne.jpg'),     
     new Movie('The lunch box', 'img/thelunchbox.jpg'),     
     new Movie('Zulu', 'img/zulu.jpg'),          
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
