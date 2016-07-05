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
getValue param =
  ScriptUtil.get Decode.float (encodeParam param) "value"


getDefaultValue : AudioParam -> PortTask x Float
getDefaultValue param =
  ScriptUtil.get Decode.float (encodeParam param) "defaultValue"


setValue : Float -> AudioParam -> PortTask x ()
setValue = setFloat "value"


setValueAtTime : Float -> Float -> AudioParam -> PortTask x ()
setValueAtTime value startTime =
  exec "setValueAtTime" [Encode.float value, Encode.float startTime]


linearRampToValueAtTime : Float -> Float -> AudioParam -> PortTask x ()
linearRampToValueAtTime value endTime =
  exec "linearRampToValueAtTime" [Encode.float value, Encode.float endTime]


exponentialRampToValueAtTime : Float -> Float -> AudioParam -> PortTask x ()
exponentialRampToValueAtTime value endTime =
  exec "exponentialRampToValueAtTime" [Encode.float value, Encode.float endTime]


setTargetAtTime : Float -> Float -> Float -> AudioParam -> PortTask x ()
setTargetAtTime target startTime timeConstant =
  exec "setTargetAtTime" [Encode.float target, Encode.float startTime, Encode.float timeConstant]


setValueCurveAtTime : Float -> Float -> Float -> AudioParam -> PortTask x ()
setValueCurveAtTime values startTime duration =
  exec "setValueCurveAtTime" [Encode.float values, Encode.float startTime, Encode.float duration]


cancelScheduledValues : Float -> AudioParam -> PortTask x ()
cancelScheduledValues startTime =
  exec "cancelScheduledValues" [Encode.float startTime]


exec : String -> List Json -> AudioParam -> PortTask x ()
exec at args param =
  ScriptUtil.exec decodeUnit (encodeParam param) at args


set : (a -> Json) -> String -> a -> AudioParam -> PortTask x ()
set encode at value param =
  ScriptUtil.set encode (encodeParam param) at value


setFloat : String -> Float -> AudioParam -> PortTask x ()
setFloat = set Encode.float
