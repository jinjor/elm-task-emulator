module TaskSim.EffectManager exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import TaskSim.PortTaskInternal as PortTask exposing (PortTask)
import Task

type alias Json = Decode.Value


type EffectManager msg =
  Manager
    { id : Int
    , tasks : Dict Int (Json -> PortTask msg msg)
    , toCmd : (Int, Json) -> Cmd msg
    }


type PortCmd msg
  = Simple (Cmd msg)
  | Callback Json (Json -> PortTask msg msg)


init : ((Int, Json) -> Cmd msg) -> EffectManager msg
init output =
  Manager
    { id = 0
    , tasks = Dict.empty
    , toCmd = output
    }


perform : (e -> msg) -> (a -> msg) -> PortTask e a -> PortCmd msg
perform transformErr transform task =
  case task of
    PortTask.Task { data, decode } ->
      Callback data
        (\json ->
          PortTask.map transform <|
          PortTask.mapError transformErr <|
          decode json
        )
    PortTask.Succeed a ->
      Simple (Task.perform transformErr transform (Task.succeed a))
    PortTask.Fail e ->
      Simple (Task.perform transformErr transform (Task.fail e))


execPortCmd : PortCmd msg -> EffectManager msg -> (Cmd msg, EffectManager msg)
execPortCmd portCmd (Manager man) =
  case portCmd of
    Simple cmd ->
      ( cmd, Manager man )
    Callback data jsonToTask ->
      ( man.toCmd (man.id, data)
      , Manager
        { id = man.id + 1
        , tasks = Dict.insert man.id jsonToTask man.tasks
        , toCmd = man.toCmd
        }
      )


transformInput : (Int, Json) -> EffectManager msg -> (Cmd msg, EffectManager msg)
transformInput (id, json) ((Manager man) as manager) =
  case Dict.get id man.tasks of
    Just decode ->
      let
        (cmd, newManager) =
          execPortCmd (perform identity identity (decode json)) manager
      in
        (cmd, newManager)
    Nothing ->
      (Cmd.none, manager)
