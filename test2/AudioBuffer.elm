module AudioBuffer exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import ScriptUtil


type alias AudioBuffer = Types.AudioBuffer


getSampleRate : AudioBuffer -> PortTask x Float
getSampleRate = getFloat "sampleRate"


getLength : AudioBuffer -> PortTask x Int
getLength = getInt "length"


getDuration : AudioBuffer -> PortTask x Float
getDuration = getFloat "duration"


getNumberOfChannels : AudioBuffer -> PortTask x Int
getNumberOfChannels = getInt "numberOfChannels"


-- TODO out of range
getChannelData : Int -> AudioBuffer -> PortTask x Float32Array
getChannelData =
  f1 "getChannelData" Encode.int decodeFloat32Array


copyFromChannel : Float32Array -> Int -> Maybe Int -> AudioBuffer -> PortTask x Float32Array
copyFromChannel =
  f3 "copyFromChannel" encodeFloat32Array Encode.int (encodeMaybe Encode.int) decodeFloat32Array


copyToChannel : Float32Array -> Int -> Maybe Int -> AudioBuffer -> PortTask x Float32Array
copyToChannel =
  f3 "copyToChannel" encodeFloat32Array Encode.int (encodeMaybe Encode.int) decodeFloat32Array


--

get : Decoder a -> String -> AudioBuffer -> PortTask x a
get decoder at node =
  ScriptUtil.get decoder (encodeBuffer node) at


getInt : String -> AudioBuffer -> PortTask x Int
getInt = get Decode.int


getFloat : String -> AudioBuffer -> PortTask x Float
getFloat = get Decode.float



f0 : String -> Decoder a -> (AudioBuffer -> PortTask x a)
f0 = ScriptUtil.f0 encodeBuffer


f1 : String -> (arg0 -> Json) -> Decoder a -> (arg0 -> AudioBuffer -> PortTask x a)
f1 = ScriptUtil.f1 encodeBuffer


f3 : String -> (arg0 -> Json) -> (arg1 -> Json) -> (arg2 -> Json) -> Decoder a -> (arg0 -> arg1 -> arg2 -> AudioBuffer -> PortTask x a)
f3 = ScriptUtil.f3 encodeBuffer
