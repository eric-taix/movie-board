## 1. Afficher l'ensemble des films
> **Objectifs :** _Comprendre la structure principale d'un projet Dart, Apprendre à créer un composant web avec Polymer, Effectuer le binding sur un objet métier, Utiliser Polymer Expressions et les filtres, Créer sa 1ère closure en Dart_  
  
  ![poster](img/goal1-user-story1.png) ![rating](img/goal2-user-story1.png) 

###Chargement du modèle métier à partir d'un flux JSON

1. Créez le fichier `services.dart` qui contiendra les services de l'application. Dans ce fichier créez une interface `MovieService` avec la méthode suivante:  
   - `getAllMovies()` renvoyant la liste des films  
   
   > Lorsqu'on effectue une opération longue (c'est le cas d'un appel réseau par exemple), Dart utilise systématiquement des `Future` qui permette de définir une opération qui se terminera plus tard dans le temps.  
   > On utilise les `Future`de la manière suivante :  
   > 
   >     Future f = operationLongue();
   >     f.then((result) {
   >       // Traitement du résultat
   >     });
   >
   > ou plus simplement
   >
   >     operationLongue().then((result) => // Traitement du résultat ));
   >
   > **La méthode du service doit donc renvoyer un `Future<List<Movie>>` afin de signifier que le résultat (qui sera une liste de films) sera retournée plus tard dans le temps.**

2. Chaque film sera initialisé à partir d'un flux JSON. Pour faciliter cette opération, créez un nouveau constructeur nommé `fromJSON` prenant en paramètre une `Map<String,Object>` et initialisez les différents attributs de la classe `Movie` à partir des clés de la `Map`. Une `Map` s'accède de la façon suivante : ```String myVar = map['key'];``` 
   
   **Les clés du flux JSON sont les suivants :**
   - `id` int contenant l'identifiant d'un film  
   - `title` String contenant le titre du film  
   - `poster_path` String contenant le chemin pour l'affiche du film
   - `release_date` String contenant la date de sortie
   - `vote_average` int contenant la note moyenne sur 10
   - `vote_count` contenant le nombre de votant

3. Dans le fichier `services.dart` créez une implémentation `InMemoryMovieService` qui implémente `MovieService`.  
   >**Note d'implémentation** Le coté back-end n'existant pas cette implementation va charger tous les films et les stocker dans une `Map<int, Movie>` (la clé étant l'id du film). Les autres méthodes du service (qui seront écrites ultérieurement feront appel à cette `Map` plutôt qu'au réseau).
   
4. Créez la méthode privée suivante :  

   ```
   Future<List<Movie>> _getMovies(String jsonUrl) {
    Completer completer = new Completer();
    HttpRequest.getString(jsonUrl).then(JSON.decode).then((List<Map> jsonMovies) {
      List<Movie> movies = jsonMovies.map((Map map) => new Movie.fromJSON(map)).toList();
      completer.complete(movies);
    });
    return completer.future;
  }
   ```
  > **Cette explication peut paraitre complexe et vous pouvez utiliser le code tel que et réserver la lecture de ce passage à la fin de cette user-story si il vous reste du temps ;-)**  
  > - ```HttpRequest.getString(<url>)``` retourne une `Future<String>` donc le résultat de la réponse sous forme de chaine (mais pas immédiatement d'où la `Future`)  
  >  
  > - La méthode `then` recoit en paramètre une fonction qui est appellée lorsque le résultat est disponible. Cette fonction est de type `(String result) { }`  
  >
  > - Cette méthode retourne une `Future<String>` : un résultat de type String sera retourné plus tard grâce à la méthode `then((String result) { })`   
  >
  > - `JSON.decode` est une méthode de la variable globale `JSON` qui prend en paramètre une `String` et qui retourne  un `dynamic` (ce que l'on veut ou rien) et en l'occurence une `List<Map>` (chaque élément de la liste est un film et chaque Map contient les attributs JSON d'un film).  
  > 
  > - Puisque `then` attend une fonction de type `(String) { }` et que `JSON.decode` correspond à cette définition, on peut lui passer directement la méthode `JSON.decode`qui sera appelée dès que le résultat sera disponible)  
  > 
  > - Le résultat de la méthode `JSON.decode` est ensuite chainé avec le 2ème `then` (on retrouve bien notre liste de Map en paramètre)  
  > 
  > - Il faut maintenant convertir nos différentes `Map`en `Movie`. Cela est réalisé grâce à la méthode `Iterable.map` qui pour chaque élément de l'itération, appelle une fonction chargée de convertir une instance de `Map`en `Movie` 
  >  
  > - La fonction qui converti le flux JSON en liste de `Movie` étant appelée de façon asynchrone, la méthode `_getMovies` a déjà retourné son résultat depuis longtemps ! Afin de prévenir que la `Future` renvoyée a fini son calcul, on utilise la méthode `Completer.complete()`
  >  
  > **Aller plus loin**:  
  > [Use Future Based APIs](https://www.dartlang.org/docs/tutorials/futures/)  
  > [Fetch Data Dynamically](https://www.dartlang.org/docs/tutorials/fetchdata/)  
  > [Collections In Dart - Dart Tips, Ep 5](https://www.dartlang.org/dart-tips/dart-tips-ep-5.html)  
  > [Using Futures in Dart for Better Async Code](http://blog.sethladd.com/2012/03/using-futures-in-dart-for-better-async.html)
   




****
    
<a name="user-story-1-hints"></a>
> **Astuces:**  
>
> - Une interface en Dart est une classe concrète (si vous avez une implémentation pour chaque méthode) ou une classe abstraite (si vous n'avez toutes les implémentations des méthodes)
>
> - Pour utiliser les `Future`il faut importer `dart:async`
>
> - Une propriété, méthode ou classe privée est simplement préfixée par un `_`


