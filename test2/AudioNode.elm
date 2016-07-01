module AudioNode exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import ScriptUtil

type alias AudioNode = Types.AudioNode


context : AudioNode -> PortTask x AudioContext
context = getContext ["context"]


numberOfOutputs : AudioNode -> PortTask x Int
numberOfOutputs = getInt ["numberOfOutputs"]


numberOfInputs : AudioNode -> PortTask x Int
numberOfInputs = getInt ["numberOfInputs"]


connect : AudioNode -> AudioNode -> PortTask x ()
connect (AudioNode src) (AudioNode dest) =
  Script.create decodeUnit [ src, dest ]
    "var src = args[0]; var dest = args[1]; src.connect(dest); done();"


disconnect : AudioNode -> PortTask x ()
disconnect = exec ["disconnect"]



-- Oscillator


start : AudioNode -> PortTask x ()
start = exec ["start"]


stop : AudioNode -> PortTask x ()
stop = exec ["stop"]


---

get : (Json -> Result x a) -> List String -> AudioNode -> PortTask x a
get decoder at (AudioNode node) =
  ScriptUtil.get decoder node at


getInt : List String -> AudioNode -> PortTask x Int
getInt = get decodeInt


getNode : List String -> AudioNode -> PortTask x AudioNode
getNode = get decodeNode


getContext : List String -> AudioNode -> PortTask x AudioContext
getContext = get decodeContext


set : (a -> String) -> List String -> a -> AudioNode -> PortTask x ()
set toString at value (AudioNode node) =
  ScriptUtil.set toString node at value


setInt : List String -> Int -> AudioNode -> PortTask x ()
setInt = set toString


setString : List String -> String -> AudioNode -> PortTask x ()
setString = set (\s -> "'" ++ s ++ "'") -- TODO escape


exec : List String -> AudioNode -> PortTask x ()
exec at (AudioNode node) =
  ScriptUtil.execUnit node at


--
