# [TodoMVC in Elm](https://github.com/evancz/elm-todomvc) - EXCEPT WITH ROCKETS 🚀🚀🚀

All of the Elm code lives in `Todo.elm` and relies on the [elm-lang/html][html] library.

[html]: http://package.elm-lang.org/packages/elm-lang/html/latest

There also is a port handler set up in `index.html` to store the Elm application's state in `localStorage` on every update.


## Build Instructions

Run the following command from the root of this project:

```bash
elm-make Todo.elm --output elm.js
```

Then open `index.html` in your browser!
