# elm-task-sim
task simulation for ports

## How to use

```elm
port input : TaskSim.Input msg

port output : TaskSim.Output msg

main =
  TaskSim.program input output
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

```

```html
<body>
<script src="script.js"></script>
<script src="task-sim.js"></script>
<script>
  var app = Elm.Main.fullscreen();
  TaskSim.configure(app.ports.input, app.ports.output, TaskSim.eval);
</script>
</body>
```

## Example

```elm
update : Msg -> Model -> (Model, Cmd Msg, PortCmd Msg)
update msg model =
  case Debug.log "msg" msg of
    Click ->
      ( model
      , Cmd.none
      , PortTask.perform
          Error
          GotValue
          (Lib.get10xValue 3 `PortTask.andThen` \i -> Lib.get10xValue i )
      )

    GotValue i ->
      (("got: " ++ toString i), Cmd.none, PortCmd.none)

    Error s ->
      ("error: " ++ s, Cmd.none, PortCmd.none)
```


## LICENSE

BSD3
