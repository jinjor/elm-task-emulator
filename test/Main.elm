port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

import TaskSim.EffectManager as EffectManager exposing (EffectManager)
import TaskSim.PortTask as PortTask exposing (PortTask)


import TaskSim.App

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Encode.Value


main =
  TaskSim.App.program input output
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


port input : ((Int, Json) -> msg) -> Sub msg

port output : (Int, Json) -> Cmd msg


type Msg
  = Click
  | GotValue Int
  | Error String


type alias Model = String


decode : Json -> Result String Int
decode data =
  let
    decoder =
      Decode.int `Decode.andThen` \i ->
        if i >= 0 then Decode.succeed i else Decode.fail "something is wrong"
  in
    Decode.decodeValue decoder data


task : Int -> PortTask String Int
task i = PortTask.map ((*) i) <| PortTask.init Encode.null decode


init : (Model, Cmd Msg)
init = ("", Cmd.none)


update : EffectManager Msg -> Msg -> Model -> (Model, Cmd Msg, EffectManager Msg)
update manager msg model =
  case msg of
    Click ->
      let
        (cmd, manager) =
          EffectManager.perform manager Error GotValue (task 3 `PortTask.andThen` \i -> task i )
      in
        (model, cmd, manager)

    GotValue i ->
      (("got: " ++ toString i), Cmd.none, manager)

    Error s ->
      ("error: " ++ s, Cmd.none, manager)


subscriptions : Model -> Sub Msg
subscriptions = always Sub.none


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Click ] [ text "Go" ]
    , div [] [ text model ]
    ]
