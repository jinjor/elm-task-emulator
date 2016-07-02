module ScriptUtil exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)

type alias AudioNode = Types.AudioNode


new : (Json -> Result x a) -> List String -> List Json -> PortTask x a
new decoder at args =
  Script.create decoder args <| done <|
    "new " ++ String.join "." at ++ arguments [0..(List.length args - 1)]


get : (Json -> Result x a) -> Json -> List String -> PortTask x a
get decoder data at =
  Script.create decoder [ data ] <| done <|
    "args[0]." ++ String.join "." at -- TODO validate


set : (a -> String) -> Json -> List String -> a -> PortTask x ()
set toString data at value =
  Script.create decodeUnit [ data ] <|
    "args[0]." ++ String.join "." at ++ " = " ++ toString value ++ ";" ++ done "" -- TODO validate, escape


exec : (Json -> Result x a) -> Json -> List String -> List Json -> PortTask x a
exec decoder data at args =
  Script.create decoder ( data :: args ) <| done <|
    "args[0]." ++ String.join "." at ++ arguments [1..(List.length args)] -- TODO validate


arguments : List Int -> String
arguments indices =
  "(" ++ String.join "," (List.map (\i -> "args[" ++ toString i ++ "]") indices) ++ ")"


done : String -> String
done s =
  "done(" ++ s ++ ");"

--


getInt : Json -> List String -> PortTask x Int
getInt = get decodeInt


setInt : Json -> List String -> Int -> PortTask x ()
setInt = set toString


setString : Json -> List String -> String -> PortTask x ()
setString = set (\s -> "'" ++ s ++ "'") -- TODO escape


execUnit : Json -> List String -> List Json -> PortTask x ()
execUnit = exec decodeUnit

--
