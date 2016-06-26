module TaskSim exposing (..)

type alias Input = ((Int, Json) -> msg) -> Sub msg

type alias Output = (Int, Json) -> Cmd msg
