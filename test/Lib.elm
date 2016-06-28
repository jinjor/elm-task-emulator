port module Lib exposing (get10xValue)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Encode.Value


decode : Json -> Result String Int
decode data =
  let
    decoder =
      Decode.int `Decode.andThen` \i ->
        if i >= 0 then Decode.succeed i else Decode.fail "something is wrong"
  in
    Decode.decodeValue decoder data


get10xValue : Int -> PortTask String Int
get10xValue i = Script.create decode [Encode.int i] "var a = args[0]; done(a * 10);"
