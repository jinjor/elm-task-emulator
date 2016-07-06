module ScriptUtil exposing
  ( get, set
  , new0, new1
  , f0, f1, f2, f3
  )

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Decode.Value


new0 : String -> Decoder a -> PortTask x a
new0 constructorName decoder =
  new decoder constructorName []

new1 : String -> (arg0 -> Json) -> Decoder a -> (arg0 -> PortTask x a)
new1 constructorName encode0 decoder = \arg0 ->
  new decoder constructorName [encode0 arg0]


new : Decoder a -> String -> List Json -> PortTask x a
new decoder constructorName args =
  Script.successful decoder args <| succeed <|
    "new " ++ constructorName ++ arguments [0..(List.length args - 1)]


get : (obj -> Json) -> String -> Decoder a -> obj -> PortTask x a
get encodeObj propertyName decoder = \obj ->
  Script.successful decoder [ encodeObj obj ] <| succeed <|
    "args[0]." ++ propertyName


set : (obj -> Json) -> String -> (a -> Json) -> a -> obj -> PortTask x ()
set encodeObj propertyName encode = \value obj ->
  Script.successful (Decode.null ()) [ encodeObj obj, encode value ] <|
    "args[0]." ++ propertyName ++ " = args[1];" ++ succeed "null" -- TODO validate, escape


f0 : (obj -> Json) -> String -> Decoder a -> (obj -> PortTask x a)
f0 encodeObj propertyName decoder = \obj ->
  exec [] decoder (encodeObj obj) propertyName


f1 : (obj -> Json) -> String -> (arg0 -> Json) -> Decoder a -> (arg0 -> obj -> PortTask x a)
f1 encodeObj propertyName encode0 decoder = \arg0 obj ->
  exec [encode0 arg0] decoder (encodeObj obj) propertyName


f2 : (obj -> Json) -> String -> (arg0 -> Json) -> (arg1 -> Json) -> Decoder a -> (arg0 -> arg1 -> obj -> PortTask x a)
f2 encodeObj propertyName encode0 encode1 decoder = \arg0 arg1 obj ->
  exec [encode0 arg0, encode1 arg1] decoder (encodeObj obj) propertyName


f3 : (obj -> Json) -> String -> (arg0 -> Json) -> (arg1 -> Json) -> (arg2 -> Json) -> Decoder a -> (arg0 -> arg1 -> arg2 -> obj -> PortTask x a)
f3 encodeObj propertyName encode0 encode1 encode2 decoder = \arg0 arg1 arg2 obj ->
  exec [encode0 arg0, encode1 arg1, encode2 arg2] decoder (encodeObj obj) propertyName


exec : List Json -> Decoder a -> Json -> String -> PortTask x a
exec args decoder data propertyName =
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
