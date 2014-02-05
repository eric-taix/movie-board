
##4. Gérer les favoris et les catégories de films


> **![image](img/goal.png)Objectifs :**  
  - Gérer des clic utilisateurs avec une seule méthode et déterminer quel élément a été cliqué  
  - Effectuer des filtres sur des listes  
  - Appliquer une classe CSS en fonction de la valeur d'un attribut du modèle  
  - Bonus : Déclencher un evénement custom et le gérer dans le composant parent
  - Extra Bonus : Stocker des données dans le local storage
  
  ![image](img/goal1-user-story-4.png)
  *Résultat obtenu à la fin de ce chapitre*

###Gérer les catégories de films

1. Dans le fichier `posters.html`, ajoutez le code suivant au dessus du `div id='movies'` :  
  
  	```
    <div id="menu" class="menu">
      <div id="all" class="item item-selected" on-click="{{showCategory}}">All</div>
      <div id="playing" class="item" on-click="{{showCategory}}">Now playing</div>
      <div id="upcoming" class="item" on-click="{{showCategory}}">Upcoming</div>      
      <div id="favorite" class="item" on-click="{{showCategory}}">Favorites</div>      
    </div>
  	```
  
   > **![image](img/tip.png) Notes :**  
   > - Les 4 `div` appellent la même méthode `showCategory`, la différenciation du `div` utilisé se fera ici via l'`id` du `div`  
   > - Nous aurions aussi pu utiliser un attribut `data-menu` et récupérer la valeur de `menu` dans le `dataset` (*cf. user story précédente*)
    
2. Dans la classe `Posters`, créez la méthode `showCategory` qui répondra au changement de menu. 

   ```
   showCategory(Event e, var detail, Element target) {
   }
   ```
   
3. Dans le fichier `posters.dart`, importez le fichier `utils.dart` et dans la méthode `showCategory`, appelez la fonction `applySelectedCSS` sur la `target` avec comme prefixe `item`.

   *Vérifiez dans Dartium le changement d'état quand vous cliquez sur un menu.*
   
4. Ajoutez dans la classe `MovieService` la méthode `Future<List<Movie>> getMovies(String tag);` qui permettra de récupérer les films ayant un tag particulier.

5. Implémentez cette nouvelle méthode de l'interface dans votre implémentation.

   ```
   Future<List<Movie>> getMovies(String tag) {
     return new Future(() {
       return _movies.where((Movie m ) => m.tag == tag).toList();
     });
   }
   ```
   *Vous pouvez écrire cette méthode sur une seule ligne !*
   
   > **![image](img/explain.png) Explications :**
   > - On effectue un filtre sur `_movies` en vérifiant l'égalité du `tag` du film avec le `tag` passé en paramètre  
   > - La méthode `where` renvoie un `LazyIterable` : il faut donc appeler la méthode `toList` !  
   > - L'égalité entre 2 objets se fait grâce à l'opérateur `==` (il est d'ailleurs possible de surcharger cet opérateur)
     
   
6. Dans la méthode `showCategory` de la classe `Posters`, ajoutez le code suivant qui, en fonction de l'id de l'élément sélectionné, appellera la bonne méthode du service pour mettre à jour la liste des films :

   ```
   switch (target.id) {
      case "all": moviesService.getAllMovies().then((List<Movie> ms) => movies = ms); break;
      case "playing": moviesService.getMovies("now_playing").then((List<Movie> ms) => movies = ms); break;
      case "upcoming": moviesService.getMovies("upcoming").then((List<Movie> ms) => movies = ms); break;
      case "favorite": // La gestion des favoris est pour plus tard
    }
    ```
   
   > **![image](img/explain.png) Explications :**  
   > - On appelle le service adéquat en fonction de l'id de la `target`
   > - Le service renvoyant une `Future`, c'est dans la callback de celle-ci que l'on peut affecter la liste des films à notre propriété `movies`
   > - `movies` étant `@observable`, sa modification entrainera un rafraichissement du template adéquat  
   
   
   > **![image](img/tip.png) Astuce :**  
   > Le code précédent est redondant. La seule partie spécifique est l'appel de la bonne méthode du service, en fonction de l'id de la `target`. Le reste est identique quelque soit le service appelé ! 
   > 
   > Une amélioration consiste donc :
   > 
   > - A créer une méthode privée permettant de mettre à jour la liste des films à partir d'une `Future`.
   >    ```
   >    _updateMovies(Future<List<Movie>> f) => f.then((List<Movie> ms) => movies = ms);
   >    ```
   > 
   > - A modifier la méthode `showCategory` de la façon suivante :
   > 
   >    ```
   >    switch (target.id) {  
   >      case "all" : _updateMovies(moviesService.getAllMovies()); break;
   >      case "playing" : _updateMovies(moviesService.getMovies("now_playing")); break;
   >      case "upcoming" : _updateMovies(moviesService.getMovies("upcoming")); break;
   >      case "favorite" : // La gestion des favoris est pour plus tard
   >    }
   >    ```
   
   *Vérifiez dans Dartium que lors d'un clic sur l'un des menus, la liste des films affichés est modifiée.*
   
###Gérer les favoris

1. Dans le fichier `poster.html`, modifiez le `span` gérant l'icone favori de la façon suivante :  
	
	```
	<span class="{{ movie.favorite | asFavoriteClass }}">&#x2665;</span>
	```
	
	> **![image](img/explain.png) Explications :**  
	> - `asFavoriteClass`est une fonction attendant un `bool` en paramètre et qui renverra une `String` contenant la classe CSS en fonction de la valeur du paramètre 
	> - En faisant ainsi, toutes modifications de la valeur de `movie.favorite` sera répercutée sur la vue
	
2. Dans la classe `Poster`, ajoutez la méthode suivante :

   ```
   asFavoriteClass(bool b) => b ? "favorite-selected" : "favorite";
   ```

   > **![image](img/explain.png) Explications :**  
   > - Cette méthode est un filtre utilisé dans le point précédent  
   > - Partant d'un `bool`, elle renvoie le nom d'une classe CSS  
   

3. Dans le fichier `poster.html`, modifiez à nouveau le `span` gérant le favori :  

   ```<span class="{{ movie.favorite | asFavoriteClass }}" on-click="{{flipFavorite}}">&#x2665;</span>```
   
4. Dans la classe `Poster`, ajoutez la méthode qui répondra au clic sur l'icone favori :  

   ```
   flipFavorite(Event e, var detail, Element target) => movie.favorite = !movie.favorite;
   ```
   *Vérifiez dans Dartium qu'un clic sur le bouton favori déclenche la permutation de son état.*

   Si l'icone ne s'affiche pas, vérifiez bien que l'attribut `favorite` du modèle est bien `@observable` et initialisé à `false` :
   ```
   @observable bool favorite = false;
   ```
   
5. Ajoutez dans `MovieService` la méthode permettant de récupérer la liste des favoris :  

   ```
   Future<List<Movie>> getFavorites();
   ```
   
6. Modifiez votre implémentation du service en vous appuyant sur l'implémentation de `getMovies` et en filtrant sur la valeur de l'attribut `favorite` de `Movie`.

7. Modifiez maintenant la méthode `showCategory` en implémentant le cas `favorite` et en appelant la méthode du service que vous venez de créer.


**A ce stade vous devriez pouvoir ajouter un film dans vos favoris et pouvoir visualiser la liste de vos favoris**
	
##![image](img/gift.png) Bonus : enlever un favori depuis la liste des favoris

*Si vous ajoutez un film dans vos favoris et que vous visualisez ensuite la liste de vos favoris, le film nouvellement ajouté apparaît. Pourtant si depuis la liste de vos favoris, vous cliquez à nouveau sur l'icone, celui-ci affiche bien son nouvel état MAIS le film n'est pas enlevé de la liste.*  
  
1. Dans la méthode `flipFavorite` de la classe `Poster`, déclenchez grâce à la méthode `PolymerElement.dispatchEvent` un evénement personnalisé (`CustomEvent`) :
  
   ```
   flipFavorite(Event e, var detail, Element target) => 
    dispatchEvent(new CustomEvent("movieupdated", detail: movie ..favorite = !movie.favorite));
   ```
  
   > **![image](img/explain.png) Explications :**  
   > - On déclenche un événement personnalisé nommé `movieupdated` avec comme détail le film qui a été modifié
   > - Pour pouvoir, sur la même ligne, effectuer le changement de valeur de l'attribut `favorite` du film et passer le film comme détail, on utilise l'opérateur cascade `..`
  
    
    [PolymerElement API](https://api.dartlang.org/docs/channels/stable/latest/polymer/PolymerElement.html)  
    [CustomEvent API](https://api.dartlang.org/docs/channels/stable/latest/dart_html/CustomEvent.html)  
   
2. Dans `posters.html` ajoutez dans le tag `<movie-poster>` la gestion de l'evénement `on-movieupdated` comme vous l'auriez fait pour l'événement `on-click`.

   ```
   <movie-poster movie="{{ m }}" on-movieupdated="{{ movieUpdated }}"></movie-poster>
   ```
   
3. Ajoutez une méthode `movieUpdated` (qui sera appelée lorsque l'événement `on-movieupdated` sera déclenché) dans la classe `Posters` et implémentez le code suivant :

   ```
   movieUpdated(Event e, Movie detail, Element target) {
    if (favMenu && !detail.favorite) movies = movies.where((Movie m) => m != detail).toList();
   }
   ```

   Concernant `favMenu`, il s'agit d'une propriété de la classe `Posters`. Faites en sorte que cet attribut ait la valeur `true` lorsque vous êtes dans le menu des favoris, et `false` sinon.
   
   > **![image](img/explain.png) Explications :**  
   > - Cette méthode est appelée lorsque l'événement `movieupdated` est déclenché.
   
   > **![image](img/tip.png) Astuce :**  
   > Il existe la méthode `remove` pour supprimer un élément. Cependant, si on utilise la méthode `remove` le favori n'est pas supprimé de la liste. Ce défaut provient du fait que `movies` est `@observable` => la vue est rafraichie lorsque l'on affecte une nouvelle liste à la propriété **MAIS PAS** si on change un élément dans la liste (ajout ou suppression).  
   > Pour faire cela, il faudrait modifier la déclaration de la propriété : `List<Movie> movies = toObservable(new List());` et ne plus affecter d'autres listes à `movies` mais faire uniquement des ajouts / suppressions sur celle-ci.

  
	
##![image](img/gift.png) Extra Bonus : Stocker les films favoris dans le local-storage

1. Dans la classe `Movie` et à la fin du constructeur nommé `fromJSON` rajoutez les lignes suivantes :

   ```
   new PathObserver(this, 'favorite').changes.listen((records) {
      window.localStorage["${id}"] = '{ "fav" : ${records[0].newValue} }';
   });
   ```
   
   > **![image](img/explain.png) Explications :**  
   > Il existe de nombreuses méthodes pour observer (unitairement ou des listes ou ...). 
   > Ici on demande à observer les changements de la propriété `favorite` sur l'instance courante et on s'abonne à ces changements.  
   > Lorsqu'un changement survient, la fonction anonyme est appelée avec en paramètre la liste des observations (dans ce cas-là une seule observation, le changement de valeur de `favorite`).
   > Lors d'un changement de valeur, on stocke la nouvelle valeur dans une chaine JSON ayant pour clé l'`id` du film.
   
   > **![image](img/tip.png) Astuces :**  
   > Le fait de stocker une chaine JSON permet d'évoluer facilement et de stocker d'autres choses sans casser les éléments déjà stockés.
   
2. Au dessus du code précédent (toujours dans le constructeur nommé `fromJSON`), ajoutez le code suivant qui va permettre de charger les préférences du favori lors de la création depuis un flux JSON :  

   ```
   favorite = false;
   try {
      String data = window.localStorage["${id}"];
      if (data != null) favorite = JSON.decode(data)["fav"];
   }
   catch(e) {
   }
   ``` 
	
   > **![image](img/explain.png) Explications :**  
   > - On charge la valeur du favori à partir du local-storage
   > - On protège le code pour éviter d'un changement de stockage qui provoquerait une erreur et ne permettrait pas à l'application de fonctionner
   