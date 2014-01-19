## 1. Show a movie's content (poster, title, average rating, ...)
> **Goal** _As a user, I want to see the poster, the title, the average rating and vote count of movie_  
  
![poster](img/goal1-user-story1.png)  ![rating](img/goal2-user-story1.png)
  
1. Start by creating a new Polymer application named `movie-board`
  - Fill the _application name_ and select _Web application (using the polymer library)_  

  ![Project creation](img/create-app.png)
  
  - Open `pubspec.yaml`: it includes project's dependencies and build's tranformers 
   
    ```YAML
      dependencies:
        polymer: any
      transformers:
        - polymer:
          entry_points: web/movie_board.html
    ```
  
    
  **Tip** : If you want to rename the main entry point of your application (ie `movie_board.html`) to something else like `index.html`, remember to modify `entry_points` in `puspec.yaml` to reflect the new name, otherwise `dart2js` will fail.
    
  - `build.dart` is launched after a file is saved, and displays Polymer warnings from the linter  
  - `clickcounter.html` and `clickcounter.dart` is a custom element named `click-counter`  
      _We're not going to work with them, you can remove them or keep them as examples_
  
      ```HTML
      <polymer-element name="click-counter" attributes="count">
        <template>
          <!-- Custom element body -->
        </template>
        <script type="application/dart" src="clickcounter.dart"></script>
      </polymer-element>
      ```
  
      ```Dart
      import 'package:polymer/polymer.dart';
      @CustomTag('click-counter')
      class ClickCounter extends PolymerElement {
        ClickCounter.created() : super.created();
      }
      ```
	  
  `clickcounter.html` imports `clickcounter.dart` and both are linked by their common name: `click-counter`
  - `movie_board.html` imports `click-counter` element to use it and initializes Dart and Polymer  
      _We're not going to work with it, you can remove it or keep it as example_
  
      ```HTML
      <head>
        <!-- import the click-counter -->
        <link rel="import" href="clickcounter.html">
        <script type="application/dart">export 'package:polymer/init.dart';</script>
        <script src="packages/browser/dart.js"></script>
      </head>
      <body>   
        <click-counter count="5"></click-counter>
      </body>
      ```
  - Right-click on `movie_board.html` and select Run in Dartium and test it
   
  
2. Next chapter