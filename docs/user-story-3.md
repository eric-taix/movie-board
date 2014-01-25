
##Effectuer des filtres et des tris sur les films  


> **Objectifs :**  
  - Utiliser des templates de répétition  
  - Répondre aux modifications d'un champ dans le template    
  - Utiliser un filtre sur une liste  
  - Publier un attribut d'un composant et utilisation de cet attribut   
  - Répondre à un événement du DOM dans le code Dart  
  - Passer des paramètres à ces événements
  - Utilisez des attributs intermédiaires pour rafraichir la vue au moment opportun  
  - Manipuler les classes CSS sur des éléments du DOM  
  - Bonus : Répondre aux modifications d'un attribut dans le code Dart et utiliser un timer pour une opération retardée dans le temps
  
  ![image](img/goal1-user-story-3.png)
  *Résultat obtenu à la fin de ce chapitre*

###Effectuer un filtre sur le titre du film

1. Modifiez le template de `Poster.hml avec le code HTML suivant et rafraichissez Dartium :  
   
   ```
    <div id="movies">
      <div class="toolbar">
        <label>Search : </label><input type="text" placeholder="Search for movie, tv show..." value="">
        <label>Sort by :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
        <a href="#" class="gb gb-left">A-Z</a>
        <a href="#" class="gb">&#x2605;</a>
        <a href="#" class="gb gb-right">&#x2665;</a>
      </div>
      <div class="content">
        <template repeat="{{m in movies}}">
          <movie-poster movie="{{movie}}"></movie-poster>
        </template>
      </div>
    </div>
   ```
   
2. Dans la classe `Posters`, ajoutez un attribut nommé `searchTerm` initialisé avec une chaine vide, observable et utilisez une Polymer expression pour afficher cet attribut dans la valeur du champ de recherche.  

3. Dans `Poster.html`, ajoutez un filtre à `movies` dans le `<template repeat=...` de cette façon :  
   
   ```
   <template repeat {{ m in movies | filter }}>
   ```
    
3. Implémentez la méthode `filter` permettant de filter la liste `movies` en vérifiant si le titre de chaque film contient le `searchTerm`  
   > **Astuces : **  
   > - Si le `searchTerm`est vide alors renvoyer toute la liste  
   > - Un filtre ne doit avoir qu'un seul paramètre du type de la variable placée à sa gauche dans la Polymer expression  
   > - Pour filtrer utilisez la méthode `List.where`  
   > - Pour vérifier si le titre d'un film contient le `searchTerm`, utilisez la méthode `String.contains` 
   >
   > [Collections In Dart - Dart Tips, Ep 5](https://www.dartlang.org/dart-tips/dart-tips-ep-5.html)  
   > [String API](https://api.dartlang.org/docs/channels/stable/latest/dart_core/String.html)

   Vérifiez le fontionnement de votre code !  
   **Cela ne fonctionne pas ! Parce que la méthode `filter` n'est pas appelée lorsque vous modifiez le `searchTerm`**
   
4. Modifiez la Polymer expression dans `Posters.html` en passant à `filter` le `searchTerm`  

5. Modifiez la signature de la méthode `filter` de la façon suivante :  
   - Un seul paramètre de type `String`   
   - Retourne une fonction qui est un filtre pour une liste de `Movie` 
   
   > **Notes :**  
   > - C'est une fonction qui renvoie une fonction  
   > - Vous pouvez écrire cette méthode sur une seule ligne : avec l'habitude c'est beaucoup plus facile à lire ;-)  
   > - C'est une Closure qui exploite le paramètre de `filter` dans l'implémentation de la fonction retournée  
   
6. Rafraichissez Dartium et tapez des termes correspondants à des parties de titre de films pour vérifier que les films sont bien filtrés en fonction du terme  

###Trier les films

1. Dans le modèle métier `Movie`, créez une `Map` `static`et `final` privée que nous nommerez `_comparators`. Cette map contiendra en clé le nom du champ qui sert de comparaison ('title', 'vote', 'favorite') et comme valeur une fonction comparant 2 instances de `Movie`  

   Initialisez cette map de la façon suivante:   

    ```  
    static final Map _comparators = {  
      "title": (Movie a, Movie b) => // comparaison sur le titre,  
      "vote": (Movie a, Movie b) => // comparaison sur le vote moyen,  
      "favorite": (Movie a, Movie b) // comparaison sur le coté favori d'un film,  
    };
    ```  
  
  
    > **Notes :**  
    > - Ajoutez l'attribut `@observable` `favorite` de type `bool`
    
2. Dans la classe `Movie` ajoutez la méthode `static getComparator` ayant pour paramètre le nom du champ sur lequel on souhaite obtenir un comparateur. Implémentez cette méthode en vous servant de la `Map` précédemment créé.

3. Dans la toolbar du template `Posters.html` modifiez les liens pour obtenir le code suivant :

   ```
   <a href="#" class="gb gb-left" on-click="{{sort}}">A-Z</a>
   <a href="#" class="gb" on-click="{{sort}}">&#x2605;</a>
   <a href="#" class="gb gb-right" on-click="{{sort}}">&#x2665;</a>
   ```
   
   > **Notes :**  
   > - C'est bien `on-click` qui est utilisé et non `onClick` (qui correspond à un appel JavaScript, vous aurez d'ailleurs un warning si vous utilisez la dernière forme)  
   > - Le nom contenu dans la Polymer expression correspond au nom de la méthode qui sera appelée lors du clic sur le lien  
 
4. Dans la classe `Posters`, ajoutez 2 attributs observable :  

   - `sortField` de type `String`
   
   - `sortAscending` de type `bool` 
   
5. Ajoutez (dans la classe `Posters`), une méthode `sortBy(String field, bool asc)`  

   - Prenez exemple sur la méthode `filter` (il s'agit d'une fonction renvoyant un filtre polymer expression)
   
   - Utilisez la méthode statique `Movie.getComparator` pour récupérer le comparateur adéquate au champ trié  
   
   - Trouvez dans les méthodes de `List`, celle qui permet de trier et celle qui permet d'inverser l'ordre en fonction du paramètre `asc`  
   
   - Pensez à utilisez l'opérateur cascade (`..`) pour appeler une méthode et retourner l'instance sur laquelle s'est effectuée l'opération. Par exemple `var result = list..forEach(print);` affiche tous les éléments de la liste et `result` est affecté avec la valeur de `lìst`.
   
   > **ATTENTION** Suivant la valeur renvoyée dans la méthode `filter`, le type passé au second filtre n'est pas forcément de type `List` mais `WhereIterable`. Il vous fait donc soit :  
   > - retourner une `List` dans `filter`  
   > - utiliser comme paramètre `Iterable<Movie>` dans la fonction renvoyée par `sortBy` et appeler la méthode `toList` de `Iterable`
   > 
   > [List API](https://api.dartlang.org/docs/channels/stable/latest/dart_core/List.html)
   
6. Dans le `template repeat` de `posters.html`, ajoutez à la suite du filtre `filter`, le filtre `sortBy`  

   > **Astuces :**  
   > 
   > - Les filtres s'enchainent avec l'opérateur `|` et sont appelés dans l'ordre ou ils apparaissent dans l'expression
   > 
   > - Utilisez les 2 attributs créés précédemment comme paramètre de la méthode `sortBy`
   
   
8. Dans la classe `Posters`, créez la méthode qui recevra les clics sur les liens :   
   
   ```
   sort(Event e, var detail, Element target) {
   }
   ```
   
9. Pour savoir sur quel lien l'utilisateur a cliqué, il faut passer un paramètre lors du clic qui permettra de faire la différence entre chaque lien. Pour cela :  
   
   - Ajoutez pour chaque lien `<a href` l'attribut `data-field` et dans l'ordre les valeurs suivantes : 'title', 'vote' et 'favorite'  
   
   - Dans la méthode `sort`, récupérez la valeur de `field` avec le code suivant : ```var field = target.dataset['field'];```  
     > **Astuce**  
     > Vous pouvez passer autant de paramètre que vous le souhaitez en utilisant des attributs ayant pour nom `data-<fieldname>="<value>"`.  
     > Pour récupérer une valeur, il suffit d'appeler `target.dataset['<fieldname>'];`  
     
   - Une fois le `field`, affectez le nom du champ trié à `sortField` et implémentez le code pour inverser le tri si le champ demandé est le même que le précédent tri.
   

Testez votre code en rafrachissant Dartium


###Appliquer un style sur un élément du DOM

Afin que l'utilisateur puisse visualiser l'ordre de tri courant nous allons appliquer un style sur certains éléments du DOM.

1. Dans le fichier `utils.dart` créez la fonction suivant :

   ```
   applySelected(Element target, String prefix) {
   }
   ```
   
   > Cette méthode va permettre d'appliquer le style `<prefix>-selected` à l'élément `target`du DOM et va supprimer ce même style à tous les éléments enfants du parent de `target`. Cette fonction est générique, elle pourra donc $etre utilisée sur n'importe quel parti du DOM.
   
2. Implémenter cette méthode en :  

   - Vérifiant d'abord que `target` ne possède pas déjà la classe CSS `<prefix>-selected`  
   
   - En supprimant cette classe CSS sur tous les enfants du parent de `target` 
   
   - Ajoutant ce style à `target`

3. Dans la méthode `sort` de la classe `Poster`, faites appel à la fonction `applySelected` en utilisant comme prefixe `"gb"`

##Bonus

Lorsque vous avez implémenté le filtre vous avez dû remarquer que, pour quasiment chaque frappe sur le clavier, le filtre se mettait en route ce qui provoque un sentiment désagréable pour l'utilisateur et n'est pas fluide...
  
1. Dans la classe `Posters` ajoutez la méthode `searchTermChanged(String oldValue)` 
   > **Notes :**  
   > - Cette méthode est appelée automatique lorsque la valeur de `searchTerm` est modifiée  
   > - `oldValue` contient la valeur précédente  
   > - Ce système est valable pour tous les attributs `@observable`d'un `PolymerElement`. Le nom de la méthode est `<attrname>Changed(E oldValue)` avec `E` étant du même type que l'attribut.  Il s'agit d'une manière élégante et facile d'être prévenu d'un changement de valeur d'un attribut observable.  
   
2. Ajoutez un attribut observable `searchFilter` et modifiez le template de `Posters.html` afin de passer en paramètre au filtre ce nouvel attribut et pas `searchTerm`. 

3. Implémentez un système qui permette de filtrer les films mais seulement après un temps de 400 ms suite à la dernière frappe de l'utilisateur (un temps inférieur annule l'opération).
  
   Les éléments suivants vous seront utiles pour parvenir au résultat :  
   - Ajoutez une attribut observable `searchFiter`  
   - Utilisez ce nouvel attribut en paramètre de `filter`  
   - Dans la méthode `searchTermChanged` implémentez un `Timer` qui au bout du temps indiqué, affectera `searchTerm` à `searchFilter`  
   - Pensez à annuler le timer si le terme change à nouveau avant que le Timer ne soit déclenché
   
   [Timer API](https://api.dartlang.org/docs/channels/stable/latest/dart_async/Timer.html)  
   [An Introduction to the dart:io Library](https://www.dartlang.org/articles/io/)
   
   
 
###[Prochaine user-story >>>](user-story-4.md)

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


