module URL exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)


createObjectURL : MediaStream -> PortTask x String
createObjectURL stream =
  ScriptUtil.exec decodeString (encodeMediaStream stream) ["createObjectURL"] []
