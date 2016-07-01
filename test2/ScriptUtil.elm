module ScriptUtil exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)

type alias AudioNode = Types.AudioNode


new : (Json -> Result x a) -> List String -> PortTask x a
new decoder at =
  Script.create decoder [ ]
    ("done(new " ++  String.join "." at ++ "());")


get : (Json -> Result x a) -> Json -> List String -> PortTask x a
get decoder data at =
  Script.create decoder [ data ] <|
    "var data = args[0]; done(data." ++ String.join "." at ++ ");"-- TODO validate


set : (a -> String) -> Json -> List String -> a -> PortTask x ()
set toString data at value =
  Script.create decodeUnit [ data ] <|
    "var data = args[0]; data." ++ String.join "." at ++ " = " ++ toString value ++ "; done();" -- TODO validate, escape


exec : (Json -> Result x a) -> Json -> List String -> PortTask x a
exec decoder data at =
  Script.create decoder [ data ] <|
    "var data = args[0]; done(data." ++ String.join "." at ++ "());"-- TODO validate



--


getInt : Json -> List String -> PortTask x Int
getInt = get decodeInt


setInt : Json -> List String -> Int -> PortTask x ()
setInt = set toString


setString : Json -> List String -> String -> PortTask x ()
setString = set (\s -> "'" ++ s ++ "'") -- TODO escape


execUnit : Json -> List String -> PortTask x ()
execUnit = exec decodeUnit

--
