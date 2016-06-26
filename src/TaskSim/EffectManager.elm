module TaskSim.EffectManager exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import TaskSim.PortTask as PortTask exposing (PortTask)
import Task

type alias Json = Decode.Value


type EffectManager msg =
  Manager
    { id : Int
    , tasks : Dict Int (Json -> PortTask msg msg)
    , toCmd : (Int, Json) -> Cmd msg
    }


init : ((Int, Json) -> Cmd msg) -> EffectManager msg
init output =
  Manager
    { id = 0
    , tasks = Dict.empty
    , toCmd = output
    }


perform : EffectManager msg -> (e -> msg) -> (a -> msg) -> PortTask e a -> (Cmd msg, EffectManager msg)
perform (Manager { id, tasks, toCmd }) transformErr transform task =
  let
    (cmd, nextTasks, newId) =
      case task of
        PortTask.PortTask { data, decode } ->
          ( toCmd (id, data)

          , let
              f json =
                PortTask.map transform <|
                PortTask.mapError transformErr <|
                decode json
            in
              Dict.insert id f tasks
          , id + 1
          )
        PortTask.Succeed a ->
          (Task.perform transformErr transform (Task.succeed a), tasks, id)
        PortTask.Fail e ->
          (Task.perform transformErr transform (Task.fail e), tasks, id)

  in
    ( cmd
    , Manager { id = newId, tasks = nextTasks, toCmd = toCmd }
    )


transformInput : (Int, Json) -> EffectManager msg -> (Cmd msg, EffectManager msg)
transformInput (id, json) ((Manager { tasks }) as manager) =
  case Dict.get id tasks of
    Just decode ->
      perform manager identity identity (decode json)
    Nothing ->
      (Cmd.none, manager)
