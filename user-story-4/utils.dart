library movie.utils;

import 'dart:html';

applySelected(Element target, String prefix) {
 String classname = "${prefix}-selected";
 if (!target.classes.contains(classname)) {
   target.parent.children.forEach((e) => e.classes.remove(classname));
   target.classes.add(classname);
 }
}