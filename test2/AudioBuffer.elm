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
getChannelData channelNumber =
  exec decodeFloat32Array "getChannelData"
    [Encode.int channelNumber]


copyFromChannel : Float32Array -> Int -> Maybe Int -> AudioBuffer -> PortTask x Float32Array
copyFromChannel destination channelNumber startInChannel =
  exec decodeFloat32Array "copyFromChannel"
    [encodeFloat32Array destination, Encode.int channelNumber, encodeMaybe Encode.int startInChannel]



copyToChannel : Float32Array -> Int -> Maybe Int -> AudioBuffer -> PortTask x Float32Array
copyToChannel source channelNumber startInChannel =
  exec decodeFloat32Array "copyToChannel"
    [encodeFloat32Array source, Encode.int channelNumber, encodeMaybe Encode.int startInChannel]


--

get : (Json -> Result x a) -> String -> AudioBuffer -> PortTask x a
get decoder at node =
  ScriptUtil.get decoder (encodeBuffer node) [at]


getInt : String -> AudioBuffer -> PortTask x Int
getInt = get decodeInt


getFloat : String -> AudioBuffer -> PortTask x Float
getFloat = get decodeFloat


exec : (Json -> Result x a) -> String -> List Json -> AudioBuffer -> PortTask x a
exec decode at args buffer =
  ScriptUtil.exec decode (encodeBuffer buffer) [at] args
