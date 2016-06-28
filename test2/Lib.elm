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


connect : AudioNode -> AudioNode -> PortTask x ()
connect (AudioNode src) (AudioNode dest) =
  Script.create decodeUnit [ src, dest ]
    "var src = args[0]; var dest = args[1]; src.connect(dest); done();"


setInt : AudioNode -> List String -> Int -> PortTask x ()
setInt (AudioNode node) at value =
  Script.create decodeUnit [ node ] <|
    "var node = args[0]; node." ++ String.join "." at ++ " = " ++ toString value ++ "; done();"-- TODO validate


setString : AudioNode -> List String -> String -> PortTask x ()
setString (AudioNode node) at value =
  Script.create decodeUnit [ node ] <|
    "var node = args[0]; node." ++ String.join "." at ++ " = '" ++ value ++ "'; done();" -- TODO validate, escape


exec : AudioNode -> List String -> PortTask x ()
exec (AudioNode node) at =
  Script.create decodeUnit [ node ] <|
    "var node = args[0]; node." ++ String.join "." at ++ "(); done();"-- TODO validate








--
