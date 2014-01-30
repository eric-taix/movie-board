
#Afficher l'ensemble des films#
-------
> **Objectifs :**  
  - Décoder un flux JSON  
  - Instancier un objet métier à partir d'un flux JSON  
  - Utiliser le `template repeat` pour afficher un ensemble de valeurs  
  - Publier un attribut d'un composant permettant de paramétrer un composant depuis l'extérieur  
  - Bonus : Charger le flux JSON à partir d'un flux HTTP
  
  
  ![poster](img/goal1-user-story-2.png)  
  *Résultat obtenu à la fin de ce chapitre*

###Chargement du modèle métier à partir d'un flux JSON

1. Créez le fichier `services.dart` qui contiendra les services de l'application. Dans ce fichier créez une classe abstraite `MovieService` avec la méthode suivante:  
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

2. Dans le fichier `services.dart` créez une chaine constante `IN_MEMORY_JSON` et initialisez la avec le contenu du fichier `common/json/all.json`.
   > **Astuces :**  
   >  
   > - Utilisez la notation chaine multilines pour plus de facilité  
   >   String s = '''  
   >   A string which is on  
   >   multiple lines  
   >   ''';
   >  
   > - Cette constante simule le contenu de la réponse HTTP que l'on recoit d'un backend, donc une chaine de caractère  
   >  
   > - Une constante est une variable initialisée et non modifiable. Contrairement à `final` la référence mais aussi le contenu sont immutables. Une constante se définit grâce au mot clé `const`.   
   
3. Chaque film sera initialisé à partir d'un flux JSON. Pour faciliter cette opération, créez un nouveau constructeur nommé `fromJSON` dans la classe `Movie` et prenant en paramètre une `Map<String,Object>` et initialisez les différents attributs de la classe `Movie` à partir des clés de la `Map`. Une `Map` s'accède de la façon suivante : ```String myVar = map['key'];``` 
   
   **Les clés du flux JSON sont les suivants :**
   - `id` int contenant l'identifiant d'un film  
   - `title` String contenant le titre du film  
   - `poster_path` String contenant le chemin pour l'affiche du film
   - `release_date` String contenant la date de sortie
   - `vote_average` int contenant la note moyenne sur 10
   - `vote_count` contenant le nombre de votant
   - `tag`String contenant une étiquette sur le type de film 
   
   > Pour l'initialisation de l'attribut `posterPath`, utilisez le chemin suivante : `../common/json/images/posters` + la valeur de l'attribut `poster_path`. Utilisez l'interpolation de chaine (sous la forme `${}` plutôt que la concaténation)
   > 
   > Certains films n'ont pas de poster. Utilisez donc l'opérateur ternaire `var x = y != null ? y : "default value";` 
  
4. Dans le fichier `services.dart` créez une implémentation `InMemoryMovieService` qui implémente `MovieService`.  
   >**Note d'implémentation :** Le coté back-end n'existant pas, cette implementation va charger tous les films et les stocker dans une `List<Movie>`. Les autres méthodes du service (qui seront écrites ultérieurement feront appel à cette `List` en mémoire plutôt qu'au réseau).  
  
5. Dans cette implémentation, ajoutez un attribut privé `_movies` et dans le constructeur par défaut initialisez cet attribut.  
   - La méthode `JSON.decode` permet de convertir une chaine en une `List<Map>`  
   - Utilisez la méthode `Iterable.map` pour convertir chaque instance de `Map`en `Movie`
   - Utilisez le constructeur `fromJSON`créé précédement  
   - Faites le sur une seule ligne !
   
   [dart:convert library](https://api.dartlang.org/docs/channels/stable/latest/dart_convert.html)  
   [Iterable.map](https://api.dartlang.org/docs/channels/stable/latest/dart_core/Iterable.html)  
   
6. Dans `MovieService` ajoutez un constructeur de type `factory` qui retourne une nouvelle instance de `InMemoryMoviesService` et ajoutez au fichier `services.dart` une variable globale `movieService` et initialisez là en créant une nouvelle instance de `MovieService`.
  
###Création du composant 'grille de films'###
1. Créez un nouveau composant nommé `movies-posters` avec les fichiers `posters.dart`et `posters.html` et géré par la classe `Posters`.  
   *=> Prenez exemple sur le composant `movie-poster`.*  
   Dans le corps du template, utilisez pour l'instant une chaine en dur.   
 
2. Remplacez le tag `movie-poster` dans le fichier `movie_board.hml` par le composant que vous venez de créer et validez que votre chaine en dur s'affiche bien dans Dartium.
   
3. Dans la classe `Posters` ajoutez un attribut `movies`qui contiendra la liste des films à afficher et dans la méthode `created()`, initialisez cet attribut en utilisant le service défini dans la variable globale `movieService`  
   > **Note :** Pour rappel le résultat d'une `Future` s'obtient dans la fonction passée en paramètre de la méthode `then((result) => // Here is your code);` de la `Fufure`

4. Remplacez le corps du `template` de `Posters.html` par le code suivant et rafrachissez Dartium:  
  
   ```  
   <template repeat="{{ m in movies }}">  
      <movie-poster></movie-poster>  
    </template>  
   ```
   
   > Un `<template repeat ...>` permet de parcourir les valeurs d'un `Iterable`
   
   **Vous devriez voir apparaître 40 posters de Dart Fligh School mais pour l'instant tous identiques !**  
   
5. Pour pouvoir fixer sur chaque poster la valeur d'un film différent, modifiez l'annotation `@observable` de l'attribut `movie`de la classe `Poster` en `@published` 

   > `@published` permet de rendre un attribut:  
   >  - observable  
   >  - non éligible au tree shaking  
   >  - d'être publié, c'est à dire visible et utilisable dans le tag du composant  
   
6. Modifiez maintenant le template de `Posters.html` en utilisant le nouvel attribut publié:  
   
   ```
   <movie-poster movie="{{ m }}"></movie-poster>
   ```
   Et rafraichissez Dartium...
   
   
###Bonus : Charger le flux JSON à partir du résultat d'une requête HTTP###
  
  1. Commencez par créer une autre implémentation de `MovieService` que vous appelerez `HttpMovieService`  
  
  2. Implémentez l'appel HTTP et le décodage de la réponse en prenant en compte les conseils suivants :  
     
     - Utilisez un attribut privé `_movies` pour stocker le résultat de `getAllMovies` (le stockage n'est à faire que si `_movies`est null)
     - Utilisez une méthode de `HttpRequest` pour effectuer votre requête HTTP  
       [HttpRequest API](https://api.dartlang.org/docs/channels/stable/latest/dart_html/HttpRequest.html)
     - Utilisez un `Completer` pour retourner le résultat de la méthode `getAllMovies`  
       [Completer API](https://api.dartlang.org/docs/channels/stable/latest/dart_async/Completer.html)  
     - Essayez de n'écrire pas plus de 6 lignes de code pour l'implémentation de `getAllMovies`
     
 
###[Prochaine user-story >>>](user-story-3.md)

****
    
<a name="user-story-1-hints"></a>
> **Astuces:**  
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


