module TaskEmulator.EffectManager exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (..)
import Task

type alias Json = Decode.Value

type EffectManager msg =
  Manager
    { id : Int
    , cmds : Dict Int (Json -> PortCmd msg)
    , toCmd : (Int, Json) -> Cmd msg
    }


init : ((Int, Json) -> Cmd msg) -> EffectManager msg
init output =
  Manager
    { id = 0
    , cmds = Dict.empty
    , toCmd = output
    }


execPortCmd : PortCmd msg -> EffectManager msg -> (Cmd msg, EffectManager msg)
execPortCmd portCmd (Manager man) =
  case portCmd of
    Simple cmd ->
      ( cmd, Manager man )
    Callback data jsonToCmd ->
      ( man.toCmd (man.id, data)
      , Manager
        { id = man.id + 1
        , cmds = Dict.insert man.id jsonToCmd man.cmds
        , toCmd = man.toCmd
        }
      )


transformInput : (Int, Json) -> EffectManager msg -> (Cmd msg, EffectManager msg)
transformInput (id, json) ((Manager man) as manager) =
  case Dict.get id man.cmds of
    Just decode ->
      execPortCmd (decode json) manager
    Nothing ->
      (Cmd.none, manager)
