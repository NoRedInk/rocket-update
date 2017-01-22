# rocket-update 🚀

This package provides a simpler alternative to the `(!)` operator.

## Tuple Rocketry

The "rocket operator" `(=>)` does nothing more than return a tuple:

```elm
("display" => "none") == ( "display", "none" )
```

## Style Rocketry

It looks kinda nice to use this for things like styles:

```elm
button [ style [ "display" => "none" ] ] [ text "invisible!" ]
```
instead of

```elm
button [ style [ ( "display", "none" ) ] ] [ text "invisible!" ]
```

## Update Rocketry

If you tweak `update` to return `( model, List (Cmd msg) )`, then you can use
`(=>)` to serve the same purpose as `(!)`, like so:

```elm
update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    case msg of
        Reset ->
            { model | stuff = newStuff } => []

        SendRequest ->
            model => [ Http.send someRequest ]

        SendOtherRequest ->
            model
                |> doSomethingToModel
                |> doSomethingElseToModel
                => [ Http.send someOtherRequest ]
```

To get an `update` function of this type, just use the `Rocket.batchUpdate` function when calling `program` and you're all set. (There's a `batchInit` function for `init` too, so `update` and `init` can be consistent.)

```elm
main : Program Never Model Msg
main =
    Html.program
        { init = init >> Rocket.batchInit
        , update = update >> Rocket.batchUpdate
        , view = view
        , subscriptions = subscriptions
        }
```

## That's it!

In the `example/` folder you can find [`elm-todomvc`](https://github.com/evancz/elm-todomvc) revised to use this style.

Enjoy! 🚀
