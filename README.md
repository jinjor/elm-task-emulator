# elm-task-emulator

task emulator for ports (WIP)

## How to use

```elm
port input : TaskEmulator.Input msg

port output : TaskEmulator.Output msg

main =
  TaskEmulator.program input output
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
```

```html
<body>
<script src="script.js"></script>
<script src="task-emulator.js"></script>
<script>
  var app = Elm.Main.fullscreen();
  TaskEmulator.configure(app.ports.input, app.ports.output, TaskEmulator.eval);
</script>
</body>
```

## Example

```elm
update : Msg -> Model -> (Model, Cmd Msg, PortCmd Msg)
update msg model =
  case msg of
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

## Context

You can use [port](http://guide.elm-lang.org/interop/javascript.html) instead of Native modules, but you cannot create Task with it.
Task is very useful, but you cannot create one without using effect manager.
It means you cannot share code that uses your own Task!

Currently, when we want to share library that work with JavaScript, you would say "Put this xxx.js file in your html file, write port in your elm file and connect them by port.". This is possible but the API would be much worse than Native modules without Tasks. Both library author and user would be unhappy.

So this library aim to emulate Task by managing outgoing and incoming messages.
You also write JavaScript in your Elm code and evaluate it outside.
Sharing these code seems to be evil, but actually it's safer than it sounds.
Using `TaskEmulator.eval` in your html file is the switch that you'll allow unsafe native code.
Otherwise, no unsafe code will be evaluated. It's just a string in the form of JavaScript code!


## LICENSE

BSD3
