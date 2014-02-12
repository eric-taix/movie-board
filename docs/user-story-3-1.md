
##3. Effectuer des filtres et des tris sur les films  


> **![image](img/goal.png) Objectifs :**  
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

1. Modifiez le template de `posters.html` avec le code HTML suivant et rafraichissez Dartium :  
   
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
        <template repeat="{{ m in movies }}">
          <movie-poster movie="{{ m }}"></movie-poster>
        </template>
      </div>
    </div>
   ```
   
   *Rafraichissez Dartium pour découvrir les ajouts dans l'interface graphique.*
   
2. Dans la classe `Posters`, ajoutez un attribut nommé `searchTerm` initialisé avec une chaine vide, observable et utilisez une Polymer expression pour afficher cet attribut dans la valeur du champ de recherche.  
   
   ```@observable String searchTerm = '';```
   
   ```<input type="text" placeholder="Search for movie, tv show..." value="{{ searchTerm }}">```
   
   > **![image](img/explain.png) Explications:**
   > La propriété `searchTerm` utilisée dans la polymer expression est lié au champ `input`. Si la valeur de la propriété est modifiée, la valeur affichée dans le champ texte sera automatiquement modifiée. Et inversement si vous saisissez une valeur dans le champ texte, la valeur de la propriété est automatiquement modifiée. 
   
3. Dans le fichier `posters.html`, ajoutez un filtre à `movies` dans le `<template repeat=...` de cette façon :  
   
   ```
   <template repeat="{{ m in movies | filter }}">
   ```
    
4. Implémentez la méthode `filter` permettant de filtrer la liste `movies` en vérifiant si le titre de chaque film contient le `searchTerm` en utilisant le code suivant :

   ```
   filter(List ms) {
     if (searchTerm.isEmpty) return movies;
     return ms.where((Movie m) {
       return m.title.toLowerCase().contains(searchTerm.toLowerCase());
     }).toList();
   }
   ```
   
   *Ce filtre peut s'écrire sur une seule ligne.*
   
   > **![image](img/explain.png) Explications :**  
   > - Si le `searchTerm`est vide alors on renvoie toute la liste  
   > - Pour filtrer on utilise la méthode `List.where`  
   > - Pour vérifier si le titre d'un film contient le `searchTerm`, on utilise la méthode `String.contains` 
   >
   > [Collections In Dart - Dart Tips, Ep 5](https://www.dartlang.org/dart-tips/dart-tips-ep-5.html)  
   > [String API](https://api.dartlang.org/docs/channels/stable/latest/dart_core/String.html)

   Vérifiez le fontionnement de votre code !  
   **Cela ne fonctionne pas ! Parce que la méthode `filter` n'est pas appelée lorsque vous modifiez le `searchTerm`.**
   
   > ![image](img/tip.png) Les templates sont évalués à la création de votre composant et chaque fois qu'un attribut observable **ET** faisant partie du template est modifié. Le problème dans le code actuel, est que la méthode `filter` n'est appelée qu'une seule fois à la création. La modification de la valeur de `searchTerm` ne relance pas l'appel à `filter` puisque `searchTerm` ne fait pas partie de l'évaluation du template.
   
5. Modifiez la Polymer expression dans `Posters.html` en passant à `filter` le `searchTerm`.
   
   ```
   <template repeat="{{ m in movies | filter(searchTerm) }}">
   ```
   
   > **![image](img/explain.png) Explication :** En ajoutant `searchTerm` dans l'évaluation du template, on force l'appel de la méthode `filter` à chaque modification de cet attribut.

6. Modifiez l'implémentation de la méthode `filter` de la façon suivante :  
   - Un seul paramètre de type `String` qui contient la valeur du terme à chercher  
   - Retourne une fonction qui filtre une liste de `Movie` 
   
   *Essayez d'écrire cette méthode sur une seule ligne.*
   
   > **![image](img/explain.png)Explications :**  
   > - C'est une fonction qui renvoie une fonction  
   > - C'est une Closure qui exploite le paramètre de `filter` dans l'implémentation de la fonction retournée  
   
7. Rafraichissez Dartium et tapez des termes correspondants à des parties de titre de films pour vérifier que les films sont bien filtrés en fonction du terme saisi.
   

###Trier les films

1. Dans le modèle métier `Movie`, créez une `Map` `static` et `final` privée que vous nommerez `_comparators`. 
   Cette map contiendra en clé le nom du champ qui sert de comparaison ('title', 'vote', 'favorite') et comme valeur une fonction comparant 2 instances de `Movie`.

   Initialisez cette map de la façon suivante (implémentez le comparator pour les champs 'vote' et 'favorite'):   

    ```  
    static final Map _comparators = {  
      "default": (Movie a, Movie b) => 0,
      "title": (Movie a, Movie b) => a.title.compareTo(b.title),  
      "vote": (Movie a, Movie b) => // comparaison sur le vote moyen (code à fournir),  
      "favorite": (Movie a, Movie b) // comparaison sur le coté favori d'un film (code à fournir),  
    };
    ```  
    
2. Dans la classe `Movie` ajoutez la méthode `static getComparator(String field)` ayant pour paramètre le nom du champ sur lequel on souhaite obtenir un comparateur. Implémentez cette méthode en retournant la bonne instance de la fonction de comparaison stockée dans `_comparators`.

3. Dans la toolbar du template `posters.html` modifiez les liens pour obtenir le code suivant :

   ```
   <a href="#" class="gb gb-left" on-click="{{sort}}" data-field="title">A-Z</a>
   <a href="#" class="gb" on-click="{{sort}}" data-field="vote">&#x2605;</a>
   <a href="#" class="gb gb-right" on-click="{{sort}}" data-field="favorite">&#x2665;</a>
   ```
   
   > **![image](img/explain.png) Explications :**  
   > - C'est bien `on-click` qui est utilisé et non `onClick` (cette dernière correspondant à un appel JavaScript, vous aurez d'ailleurs un warning si vous utilisez la dernière forme)  
   > - Le nom contenu dans la Polymer expression correspond au nom de la méthode qui sera appelée lors du clic sur le lien  
   > - L'attribut `data-field`, sert à ajouter un paramètre, ce dernier sera interprété afin de connaitre sur quel champ l'utilisateur désire effectuer le tri (une autre solution aurait consisté à définir 3 méthodes différentes: `sortByTitle`, `sortByVote`, `sortByFavorite`)
  
4. Dans la classe `Posters`, ajoutez 2 attributs observable :  
   - `sortField` de type `String` (initialisé avec la valeur `default`)  
   - `sortAscending` de type `bool` (initialisé avec la valeur `true`)  
   
5. Dans la classe `Posters`, créez la méthode qui recevra les clics sur les liens :   
   
   ```
   sort(Event e, var detail, Element target) {
      var field = target.dataset['field'];
      sortAscending = field == sortField ? !sortAscending : true;
      sortField = field;
   }
   ```
   > **![image](img/tip.png) Note :**  
   > 
   > - Les classes `Event` et `Element` nécessitent l'import suivant : `import 'dart:html';`.
   
   > **![image](img/explain.png) Explication :**  
   > - On récupère la valeur du paramètre défini dans `data-field` en récupérant sa valeur dans `target.dataset` (si l'attribut du tag à été défini par `data-xyz` alors le nom de la clé à utiliser est `xyz`)  
   > - Si le champ est le même que le champ courant, on change l'ordre de tri  
 
6. Modifiez dans `posters.html` le `template repeat` de la façon suivante :  

   ```
   <template repeat="{{ m in movies | filter(searchTerm) | sortBy(sortField, sortAscending) }}">
   ``` 

   > **![image](img/tip.png) Note :**  
   > 
   > - Les filtres s'enchainent avec l'opérateur `|` et sont appelés dans l'ordre ou ils apparaissent dans l'expression : les films sont passés au filtre `filter` et le résultat est passé à son tour au filtre `sortBy`
    
7. Créez dans la classe `Posters`, la méthode `sortBy(String field, bool asc)`.

   ```
   sortBy(String field, bool asc) => (Iterable<Movie> ms) {
     List result = ms.toList()..sort(Movie.getComparator(field));
     return asc ? result : result.reversed;
   };
   ```

   > **![image](img/explain.png) Explications :**  
   > - Il s'agit encore une fois d'une Closure  
   > - La fonction `sortBy` renvoie un filtre polymer, c'est à dire une fonction ayant pour paramètre une liste de `Movie` et renvoyant une liste de `Movie` triée  
   > - La méthode `filter` retourne un `Iterable` qui ne possède pas de méthode de tri. Il faut donc récupérer un `List` pour pouvoir effectuer un tri  
   > - L'opérateur cascade `..` est utilisé afin de pouvoir trier la liste et affecter la variable `result` sur une seule ligne  
   > - Si le tri est descendant, on inverse la liste grâce à la méthode `reversed` de `List`  
   > [List API](https://api.dartlang.org/docs/channels/stable/latest/dart_core/List.html)
   
  *Testez votre code en rafraichissant Dartium.*

   ![image](img/tip.png) **Le principe du code précédent est le suivant :**  
  1- Un click sur l'un des liens appelle la méthode `sort`  
  2- La méthode `sort` affecte les attributs `sortAscending` et `sortField`  
  3- Ces attributs étant utilisés dans l'expression polymer `{{ m in movies | filter(searchTerm) | sortBy(sortField, sortAscending) }}`, le template est réévalué  
  4- La méthode `sortBy` est donc appelée avec les nouvelles valeurs de tri  
  5- Celle-ci renvoie les films triés (et filtrés par `filter`)


###Appliquer un style sur un élément du DOM

Afin que l'utilisateur puisse visualiser l'ordre de tri courant nous allons appliquer un style sur certains éléments du DOM.

1. Créez le fichier `utils.dart` et ajoutez la fonction suivante :

   ```
   applySelected(Element target, String prefix) {
     String classname = "${prefix}-selected";
     if (!target.classes.contains(classname)) {
       target.parent.children.forEach((e) => e.classes.remove(classname));
       target.classes.add(classname);
     }
   }
   ```
   
   > **![image](img/explain.png) Explications :**  
   > Cette méthode va permettre d'appliquer le style `<prefix>-selected` à l'élément `target` du DOM et va supprimer ce même style à tous les éléments frères de `target`.
   > Cette fonction est générique, elle pourra donc être utilisée sur n'importe quelle partie du DOM.

3. Dans la méthode `sort` de la classe `Posters`, faites appel à la fonction `applySelected` en utilisant comme prefixe `"gb"` et en l'appliquant à `target`.

   *Vérifiez dans Dartium que vous visualisez bien sur quel champ est effectué le tri lorsque vous cliquez sur l'un des boutons de tri.*  


##![image](img/gift.png)Bonus

Lorsque vous avez implémenté le filtre vous avez dû remarquer que, pour quasiment chaque frappe sur le clavier, le filtre se mettait en route ce qui provoque un sentiment désagréable pour l'utilisateur et n'est pas fluide...
  
1. Dans la classe `Posters` ajoutez la méthode `searchTermChanged(String oldValue)`.
   > **![image](img/explain.png) Notes :**  
   > - Cette méthode est appelée automatiquement lorsque la valeur de `searchTerm` est modifiée  
   > - `oldValue` contient la valeur précédente  
   > - Ce système est valable pour tous les attributs `@observable`d'un `PolymerElement`. Le nom de la méthode est `<attrname>Changed(E oldValue)` avec `E` étant du même type que l'attribut.  Il s'agit d'une manière élégante et facile d'être prévenu d'un changement de valeur d'un attribut observable.  

2. Implémentez un système qui permette de filtrer les films mais seulement après un temps de 400 ms suite à la dernière frappe de l'utilisateur (un temps inférieur annule l'opération).
  
   ![image](img/tip.png) Les éléments suivants vous seront utiles pour parvenir au résultat :  
   - Ajoutez un attribut observable `searchFilter`  
   - Utilisez ce nouvel attribut en paramètre de `filter` à la place de `searchTerm`
   - Dans la méthode `searchTermChanged` implémentez un `Timer` qui au bout du temps indiqué, affectera la valeur de `searchTerm` à `searchFilter`  
   - Pensez à annuler le timer si le terme change à nouveau avant que le Timer ne soit déclenché
   
   [Timer API](https://api.dartlang.org/docs/channels/stable/latest/dart_async/Timer.html)  
   
   
 
###[Prochaine user-story >>>](user-story-4-1.md)



