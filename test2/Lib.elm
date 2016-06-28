port module Lib exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Encode.Value


type AudioContext = AudioContext Json

type AudioNode = AudioNode Json


decodeContext : Json -> Result x AudioContext
decodeContext node =
  Ok (AudioContext node)


decodeNode : Json -> Result x AudioNode
decodeNode node =
  Ok (AudioNode node)


decodeUnit : Json -> Result x ()
decodeUnit _ =
  Ok ()


decodeInt : Json -> Result x Int
decodeInt json =
  case Decode.decodeValue Decode.int json of
    Ok i -> Ok i
    _ -> Debug.crash ("not int: " ++ toString json)


newAudioContext : PortTask x AudioContext
newAudioContext =
  Script.create decodeContext [ ]
    "done(new AudioContext());"


createOscillator : AudioContext -> PortTask x AudioNode
createOscillator (AudioContext context) =
  Script.create decodeNode [ context ]
    "var context = args[0]; done(context.createOscillator());"


createGain : AudioContext -> PortTask x AudioNode
createGain (AudioContext context) =
  Script.create decodeNode [ context ]
    "var context = args[0]; done(context.createGain());"


destination : AudioContext -> PortTask x AudioNode
destination (AudioContext context) =
  Script.create decodeNode [ context ]
    "var context = args[0]; done(context.destination);"


numberOfOutputs : AudioNode -> PortTask x Int
numberOfOutputs = getInt ["numberOfOutputs"]


numberOfInputs : AudioNode -> PortTask x Int
numberOfInputs = getInt ["numberOfInputs"]


connect : AudioNode -> AudioNode -> PortTask x ()
connect (AudioNode src) (AudioNode dest) =
  Script.create decodeUnit [ src, dest ]
    "var src = args[0]; var dest = args[1]; src.connect(dest); done();"


disconnect : AudioNode -> PortTask x ()
disconnect (AudioNode node) =
  Script.create decodeUnit [ node ]
    "var node = args[0]; node.disconnect(); done();"


getInt : List String -> AudioNode -> PortTask x Int
getInt at (AudioNode node) =
  Script.create decodeInt [ node ] <|
    "var node = args[0]; done(node." ++ String.join "." at ++ ");"-- TODO validate


setInt : List String -> Int -> AudioNode -> PortTask x ()
setInt at value (AudioNode node) =
  Script.create decodeUnit [ node ] <|
    "var node = args[0]; node." ++ String.join "." at ++ " = " ++ toString value ++ "; done();"-- TODO validate


setString : List String -> String -> AudioNode -> PortTask x ()
setString at value (AudioNode node) =
  Script.create decodeUnit [ node ] <|
    "var node = args[0]; node." ++ String.join "." at ++ " = '" ++ value ++ "'; done();" -- TODO validate, escape


exec : AudioNode -> List String -> PortTask x ()
exec (AudioNode node) at =
  Script.create decodeUnit [ node ] <|
    "var node = args[0]; node." ++ String.join "." at ++ "(); done();"-- TODO validate








--
