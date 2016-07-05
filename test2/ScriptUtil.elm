module ScriptUtil exposing
  ( new, get, set, exec
  , getInt, getFloat, getBool, getString
  , setInt, setFloat, setBool, setString
  )

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Decode.Value


new : Decoder a -> String -> List Json -> PortTask x a
new decoder constructorName args =
  Script.successful decoder args <| succeed <|
    "new " ++ constructorName ++ arguments [0..(List.length args - 1)]


get : Decoder a -> Json -> String -> PortTask x a
get decoder data propertyName =
  Script.successful decoder [ data ] <| succeed <|
    "args[0]." ++ propertyName


set : (a -> Json) -> Json -> String -> a -> PortTask x ()
set encode data propertyName value =
  Script.successful (Decode.null ()) [ data, encode value ] <|
    "args[0]." ++ propertyName ++ " = args[1];" ++ succeed "null" -- TODO validate, escape


exec : Decoder a -> Json -> String -> List Json -> PortTask x a
exec decoder data propertyName args =
  Script.successful decoder ( data :: args ) <| succeed <|
    ("args[0]." ++ propertyName ++ arguments [1..(List.length args)] ++ "|| null") -- TODO validate


arguments : List Int -> String
arguments indices =
  "(" ++ String.join "," (List.map (\i -> "args[" ++ toString i ++ "]") indices) ++ ")"


succeed : String -> String
succeed s =
  "succeed(" ++ s ++ ");"


fail : String -> String
fail s =
  "fail(" ++ s ++ ");"

--


getInt : Json -> String -> PortTask x Int
getInt = get Decode.int


getFloat : Json -> String -> PortTask x Float
getFloat = get Decode.float


getBool : Json -> String -> PortTask x Bool
getBool = get Decode.bool


getString : Json -> String -> PortTask x String
getString = get Decode.string


setInt : Json -> String -> Int -> PortTask x ()
setInt = set Encode.int


setFloat : Json -> String -> Float -> PortTask x ()
setFloat = set Encode.float


setBool : Json -> String -> Bool -> PortTask x ()
setBool = set Encode.bool


setString : Json -> String -> String -> PortTask x ()
setString = set Encode.string



--
