module AudioParam exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import ScriptUtil


type alias AudioParam = Types.AudioParam


getValue : AudioParam -> PortTask x Float
getValue = get "value" Decode.float


getDefaultValue : AudioParam -> PortTask x Float
getDefaultValue = get "defaultValue" Decode.float


setValue : Float -> AudioParam -> PortTask x ()
setValue = set "value" Encode.float


setValueAtTime : Float -> Float -> AudioParam -> PortTask x ()
setValueAtTime =
  f2 "setValueAtTime" Encode.float Encode.float decodeUnit


linearRampToValueAtTime : Float -> Float -> AudioParam -> PortTask x ()
linearRampToValueAtTime =
  f2 "linearRampToValueAtTime" Encode.float Encode.float decodeUnit


exponentialRampToValueAtTime : Float -> Float -> AudioParam -> PortTask x ()
exponentialRampToValueAtTime =
  f2 "exponentialRampToValueAtTime" Encode.float Encode.float decodeUnit


setTargetAtTime : Float -> Float -> Float -> AudioParam -> PortTask x ()
setTargetAtTime =
  f3 "setTargetAtTime" Encode.float Encode.float Encode.float decodeUnit


setValueCurveAtTime : Float -> Float -> Float -> AudioParam -> PortTask x ()
setValueCurveAtTime =
  f3 "setValueCurveAtTime" Encode.float Encode.float Encode.float decodeUnit


cancelScheduledValues : Float -> AudioParam -> PortTask x ()
cancelScheduledValues =
  f1 "cancelScheduledValues" Encode.float decodeUnit


f0 : String -> Decoder a -> (AudioParam -> PortTask x a)
f0 = ScriptUtil.f0 encodeParam


f1 : String -> (arg0 -> Json) -> Decoder a -> (arg0 -> AudioParam -> PortTask x a)
f1 = ScriptUtil.f1 encodeParam


f2 : String -> (arg0 -> Json) -> (arg1 -> Json) -> Decoder a -> (arg0 -> arg1 -> AudioParam -> PortTask x a)
f2 = ScriptUtil.f2 encodeParam


f3 : String -> (arg0 -> Json) -> (arg1 -> Json) -> (arg2 -> Json) -> Decoder a -> (arg0 -> arg1 -> arg2 -> AudioParam -> PortTask x a)
f3 = ScriptUtil.f3 encodeParam


get : String -> Decoder a -> AudioParam -> PortTask x a
get = ScriptUtil.get encodeParam


set : String -> (a -> Json) -> a -> AudioParam -> PortTask x ()
set = ScriptUtil.set encodeParam
