module Rocket exposing ((=>), batchInit, batchUpdate)

{-| This module contains the "rocket operator" `(=>)`, as well as functions
to tweak `update` and `init` so that they work naturally with it.

@docs (=>)

@docs batchUpdate, batchInit
-}


{-| Returns a tuple. Lets you write:

    button [ style [ "display" => "none" ] ] [ text "Yo" ]

instead of

    button [ style [ ( "display", "none" ) ] ] [ text "Yo" ]

Also works great for `update` functions, especially those that return
`( model, List (Cmd msg) )` like so:

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

See [`batchUpdate`](#batchUpdate) for how to obtain an `update` function like this.
-}
(=>) : a -> b -> ( a, b )
(=>) =
    (,)


{-| infixl 0 means the (=>) operator has the same precedence as (<|) and (|>),
meaning you can use it at the end of a pipeline and have the precedence work out.
-}
infixl 0 =>


{-| Use this with `program` to make `init` return `( model, List (Cmd msg) )`

    main : Program Never Model Msg
    main =
        Html.programWithFlags
            { init = init >> Rocket.batchInit
            , update = update >> Rocket.batchUpdate
            , view = view
            , subscriptions = subscriptions
            }
-}
batchInit : ( model, List (Cmd msg) ) -> ( model, Cmd msg )
batchInit =
    batchCommands


{-| Use this with `program` to make `update` return `( model, List (Cmd msg) )`

    main : Program Never Model Msg
    main =
        Html.program
            { init = init >> Rocket.batchInit
            , update = update >> Rocket.batchUpdate
            , view = view
            , subscriptions = subscriptions
            }
-}
batchUpdate : (model -> ( model, List (Cmd msg) )) -> model -> ( model, Cmd msg )
batchUpdate fn =
    fn >> batchCommands


{-| Used internally for batchInit and batchUpdate
-}
batchCommands : ( model, List (Cmd msg) ) -> ( model, Cmd msg )
batchCommands ( model, commands ) =
    model => Cmd.batch commands
