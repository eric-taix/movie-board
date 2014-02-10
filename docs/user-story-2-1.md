
#2. Afficher l'ensemble des films#

> **![image](img/goal.png) Objectifs :**  
  - Décoder un flux JSON  
  - Instancier un objet métier à partir d'un flux JSON  
  - Utiliser le `template repeat` pour afficher un ensemble de valeurs  
  - Publier un attribut d'un composant permettant de paramétrer un composant depuis l'extérieur  
  - Bonus : Charger le flux JSON à partir d'un flux HTTP
  
  
  ![poster](img/goal1-user-story-2.png)  
  *Résultat obtenu à la fin de ce chapitre*

###Chargement du modèle métier à partir d'un flux JSON

1. Créez le fichier `services.dart` qui contiendra les services de l'application. Dans ce fichier, créez une classe abstraite `MovieService` avec la méthode suivante :  
   
   ```
   abstract class MovieService {  
     Future<List<Movie>> getAllMovies(); // renvoie la liste des films  
   }
   ```
   > **![image](img/tip.png) Astuces :**  
   > N'oubliez pas :  
   > - de définir le nom de la librairie grâce au mot clé `library`  
   > - d'importer la librairie `dart:async` qui permet d'utiliser la classe `Future`  
   > - d'importer le fichier dart qui contient votre modèle


   > **![image](img/explain.png) Explications :**
   > Lorsque l'on effectue une opération longue (c'est le cas d'un appel réseau par exemple), Dart utilise systématiquement des `Future` qui permettent de définir une opération qui se terminera plus tard dans le temps.  
   > On utilise les `Future` de la manière suivante :  
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
   > **La méthode du service doit donc renvoyer un `Future<List<Movie>>` afin de signifier que le résultat (qui sera une liste de films) sera retourné plus tard dans le temps.**

2. Dans le fichier `services.dart`, en dehors de la classe `MovieService`, créez une chaine constante `IN_MEMORY_JSON` et initialisez-la avec le contenu du fichier `common/json/all.json`.
   > **![image](img/tip.png) Astuce :**  
   >  
   > - Utilisez la notation chaine multilignes pour plus de facilité :
   >   ```
   >   String s = '''  
   >   A string which is on  
   >   multiple lines  
   >   ''';
   >   ```
   >  
   > - Cette constante simule la réponse HTTP que l'on reçoit d'un backend, donc une chaine de caractère
   >  
   > - Une constante est une variable initialisée et non modifiable. Contrairement à `final`, la référence mais aussi le contenu sont immutables. Une constante se définit grâce au mot clé `const`
   
   *Extrait :*  
   
   ```
   const String IN_MEMORY_JSON = '''
[
  {
  "tag":"upcoming","adult": false,
  "id": 180894,
  "original_title": "Ninja: Shadow of a Tear",
  ...
  ...
  "title": "Force of Execution",
  "vote_average": 7.5,
  "vote_count": 4
  }]
''';
  ```
3. Chaque film sera initialisé à partir d'un flux JSON. Pour faciliter cette opération, créez un nouveau constructeur nommé `fromJSON` dans la classe `Movie` et prenant en paramètre une `Map<String,Object>` et initialisez les différents attributs de la classe `Movie` à partir des clés de la `Map` de la façon suivante :  
  
   ```
  Movie.fromJSON(Map<String, Object> json) {
    id=json['id'];
    title=json['title'];
    posterPath=json['poster_path'] != null ? "../common/json/images/posters${json['poster_path']}" : "../common/img/no-poster-w130.jpg";
    releasedDate=json['release_date'];
    voteAverage=(json['vote_average'] as num).toInt();
    voteCount=json['vote_count'];
    tag=json['tag'];
  }
   ``` 
   *Le constructeur `fromJSON` et la méthode `toJSON` sont 'normalisés', d'ailleurs la prochaine version de Dart Editor propose un générateur automatique à partir des attributs de la classe.*
   
   **Les clés du flux JSON sont les suivantes :**
   - `id` int contenant l'identifiant d'un film  
   - `title` String contenant le titre du film  
   - `poster_path` String contenant le chemin pour l'affiche du film
   - `release_date` String contenant la date de sortie
   - `vote_average` int contenant la note moyenne sur 10
   - `vote_count` contenant le nombre de votant
   - `tag`String contenant une étiquette sur le type de film
   
4. Dans le fichier `services.dart` créez une implémentation `InMemoryMovieService` qui implémente `MovieService`.    
  
   ```
   class InMemoryMovieService implements MovieService {
   
   }
   ```
  
5. Dans cette implémentation, ajoutez un attribut privé `List<Movie> _movies` et dans le constructeur par défaut initialisez cet attribut.  
   
   ```
   InMemoryMovieService() {
      _movies = JSON.decode(IN_MEMORY_JSON).map((Map map) {
        return new Movie.fromJSON(map);
      }).toList();
   }
   ``` 
   - La méthode `JSON.decode` permet de convertir une chaine en une `List<Map>`  
   - La méthode `Iterable.map` permet de convertir chaque instance de `Map`en `Movie`
   - La création de chaque film est effectuée par le constructeur `fromJSON`créé précédement  
   - La méthode ```toList()``` permet de forcer le parcours de la liste et donc d'effectuer le traitement  
   - Vous devez importer ```import 'dart:convert';``` qui contient la classe ```JSON```
   
   *Vous pouvez écrire cette méthode sur une seule ligne ;-)*
   
   [dart:convert library](https://api.dartlang.org/docs/channels/stable/latest/dart_convert.html)  
   [Iterable.map](https://api.dartlang.org/docs/channels/stable/latest/dart_core/Iterable.html)

6. N'oubliez pas d'implémenter la méthode `getAllMovies()`.

   ```
   Future<List<Movie>> getAllMovies() => new Future(() => _movies);
   ```
  
  
   >**Note d'implémentation :**  
   >- Le coté back-end n'existant pas, cette implémentation va charger tous les films et les stocker dans une `List<Movie>`. Les autres méthodes du service (qui seront écrites ultérieurement) feront appel à cette `List` en mémoire plutôt qu'au réseau.  
   >- Le constructeur `new Future(() => _movies);` permet de retourner la liste des films (qui est déjà connue) à travers une instance de `Future`


7. Dans `MovieService` ajoutez un constructeur de type `factory` qui retourne une nouvelle instance de `InMemoryMoviesService`. 
  
   ```
   factory MovieService() => new InMemoryMovieService();
   ```
    
   Ajoutez au fichier `services.dart` une variable globale `moviesService` et initialisez-la en créant une nouvelle instance de `MovieService`.
   
   ```
   final MovieService moviesService = new MovieService();
   ```
   
   > **![image](img/explain.png) Note :** Même si la classe ```MovieService``` est abstraite, le fait de créer un constructeur de type ```factory``` permet de pouvoir faire comme si on crée une instance de ```MovieService``` (le détail de l'implémentation réelle étant caché et permettant d'être modifié sans impacter les clients).
  
###Création du composant 'grille de films'###
1. Créez un nouveau composant nommé `movie-posters` avec les fichiers `posters.dart`et `posters.html` et géré par la classe `Posters`.  
   
   posters.html :
   
   ```
   <polymer-element name='movie-posters'>
    <template>
      <p>Posters</p>
    </template>
    <script type="application/dart" src="posters.dart"></script>
   </polymer-element>
   ```
   
   posters.dart :  
   
   ```
   library movie.posters;

   import 'package:polymer/polymer.dart';
   
   import 'models.dart';

   @CustomTag('movie-posters')
   class Posters extends PolymerElement {
  
     bool get applyAuthorStyles => true;
  
     Posters.created() : super.created();
   }
   ``` 
 
2. Remplacez le tag `movie-poster` dans le fichier `movie_board.hml` par le tag `movie-posters` que vous venez de créer et validez que votre chaine en dur s'affiche bien dans Dartium.
   
3. Dans la classe `Posters` ajoutez un attribut `movies` qui contiendra la liste des films à afficher et dans la méthode `created()`, initialisez cet attribut en utilisant le service défini dans la variable globale `movieService`.

   ```
   @observable List<Movie> movies;
   ```

   ```
    Posters.created() : super.created() {
      moviesService.getAllMovies().then((List ms) => movies = ms);
    }
   ```
 
   > **![image](img/explain.png) Note :** Pour rappel, le résultat d'une `Future` s'obtient dans la fonction passée en paramètre de la méthode `then((result) => // Here is your code);` de la `Fufure`.

   
4. Remplacez le corps du `template` de `posters.html` par le code suivant et rafraichissez Dartium.
  
   ```  
  <template>
    <template repeat="{{ m in movies }}">
      <movie-poster></movie-poster>
    </template>
  </template> 
   ```
   
   > **![image](img/explain.png) Explications :**  
   > - Un `<template repeat ...>` permet de parcourir les valeurs d'un `Iterable`
   
   
   > **![image](img/tip.png) Astuce :**  
   > Si vous utilisez une classe dans un fichier Dart, vous devez avoir importé la librairie qui définie cette classe. Il en est de même pour les composants Polymer : pour pouvoir les utiliser vous devez importer le fichier HTML qui le défini ! Prenez exemple sur le fichier `movie_board.html`   
   
   **Vous devriez voir apparaître 40 posters de Dart Flight School mais pour l'instant tous identiques !**  
   
5. Pour pouvoir fixer sur chaque poster la valeur d'un film différent, modifiez l'annotation `@observable` de l'attribut `movie` de la classe `Poster` en `@published`.

   > **![image](img/explain.png) Explications :**  
   > `@published` permet de rendre un attribut :  
   >  - observable  
   >  - non éligible au tree shaking  
   >  - d'être publié, c'est à dire visible et utilisable dans le tag du composant  
   
6. Modifiez maintenant le template de `posters.html` en utilisant le nouvel attribut publié.
   
   ```
   <movie-poster movie="{{ m }}"></movie-poster>
   ```
   Et rafraichissez Dartium...
   
   
###![image](img/gift.png) Bonus : Charger le flux JSON à partir du résultat d'une requête HTTP###
  
  1. Commencez par créer une autre implémentation de `MovieService` que vous appelerez `HttpMovieService`  
  
  2. Implémentez l'appel HTTP et le décodage de la réponse en prenant en compte les conseils suivants :  
     
     - Utilisez un attribut privé `_movies` pour stocker le résultat de `getAllMovies` (le stockage n'est à faire que si `_movies` n'est pas encore initialisé , valeur à null)
     - Utilisez une méthode de `HttpRequest` pour effectuer votre requête HTTP  
       [HttpRequest API](https://api.dartlang.org/docs/channels/stable/latest/dart_html/HttpRequest.html)  
     - Utilisez le chemin `../common/json/all.json` pour votre requête HTTP ce qui lira le fichier `all.json` et le renverra
     - Utilisez un `Completer` pour retourner le résultat de la méthode `getAllMovies`  
       [Completer API](https://api.dartlang.org/docs/channels/stable/latest/dart_async/Completer.html)  
     - Essayez de n'écrire pas plus de 6 lignes de code pour l'implémentation de `getAllMovies`  
     - Pensez à modifier votre factory de `MovieService` avec votre nouvelle implémentation pour la tester
     
 
###[Prochaine user-story >>>](user-story-3-1.md)

****
    
<a name="user-story-1-hints"></a>
> **![image](img/tip.png)Astuces :**  
>
> - Une interface en Dart est une classe concrète (si vous avez une implémentation pour chaque méthode) ou une classe abstraite (si vous n'avez toutes les implémentations des méthodes)
>
> - Pour utiliser les `Future`il faut importer `dart:async`
>
> - Une propriété, méthode ou classe privée est simplement préfixée par un `_`  
>
> - Il faut toujours importer le fichier HTML d'un composant que l'on souhaite utiliser par `<link rel="import" ..>`
>
> - Un constructeur de type `factory` permet de contrôler ce qui est réellement créé. Les cas d'utilisation sont variés, comme retourner une implémentation différente, retourner une instance d'un cache plutôt qu'une nouvelle valeur, retourner un Singleton. Son nom est apparenté au pattern du même nom.  
> 
> - Un grand nombre des méthodes de `Iterable` retournent des `LazyIterable`. Sur ce type de liste les éléments ne sont parcourus que lorsque l'on y accède et ceci à des fins d'optimisation. Pour affecter un `LazyIterable` a une `List`, il faut appeler la méthode `toList()` sinon une erreur est déclenchée.
> 
> **Aller plus loin**:  
> 
> [Use Future Based APIs](https://www.dartlang.org/docs/tutorials/futures/)  
> [Fetch Data Dynamically](https://www.dartlang.org/docs/tutorials/fetchdata/)  
> [Collections In Dart - Dart Tips, Ep 5](https://www.dartlang.org/dart-tips/dart-tips-ep-5.html)  
> [Using Futures in Dart for Better Async Code](http://blog.sethladd.com/2012/03/using-futures-in-dart-for-better-async.html)


