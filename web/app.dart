library movies.app;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:route/client.dart';
import 'package:route/url_pattern.dart';

@CustomTag('movie-app')
class Application extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  // Define all routes starting from specific routes to general route (typicaly home route should be defined at the end)
  Route movieRoute = new Route('movie.view', new UrlPattern(r'/(.*)#/movies/(\d+)'));
  Route homeRoute = new Route('home', new UrlPattern(r'/(.*)'));
  
  @observable Route route;
  
  Application.created() : super.created() {
    Router router = new Router()
    ..addHandler(movieRoute.pattern, _routeHandler(movieRoute))
    ..addHandler(homeRoute.pattern, _routeHandler(homeRoute))
    ..listen();
    route = homeRoute;
  }
  
  /// Handles the new route by setting the current route to the new route
  Handler _routeHandler(Route newRoute) => (String path) {
    route = newRoute;
    route.applyPath(path);
  };
  
  goBack(Event e, var detail, Element target) {
    window.history.back();
  }
  
  int asInt(String value) => int.parse(value); 
}

@observable
class Route {
  String _name;
  UrlPattern _pattern;
  List _parameters;
  
  String get name => name;
  UrlPattern get pattern => _pattern;
  
  Route(this._name, this._pattern);
  
  applyPath(String path) => _parameters = _pattern.parse(path);
  
  /// Returns the parameter at position [index] (first parameter is index 1)
  operator [](int index) => index < _parameters.length ? _parameters[index] : null;
}