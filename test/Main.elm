port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

import TaskSim.PortTask as PortTask exposing (PortTask)
import TaskSim.PortCmd as PortCmd exposing (PortCmd)

import TaskSim.App as TaskSim

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Encode.Value


main =
  TaskSim.program input output
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


port input : TaskSim.Input msg

port output : TaskSim.Output msg


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
task i = PortTask.create (Encode.int i) decode


init : (Model, Cmd Msg)
init = ("", Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg, PortCmd Msg)
update msg model =
  case Debug.log "msg" msg of
    Click ->
      (model, Cmd.none, PortTask.perform Error GotValue (task 3 `PortTask.andThen` \i -> task i ))

    GotValue i ->
      (("got: " ++ toString i), Cmd.none, PortCmd.none)

    Error s ->
      ("error: " ++ s, Cmd.none, PortCmd.none)


subscriptions : Model -> Sub Msg
subscriptions = always Sub.none


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Click ] [ text "Go" ]
    , div [] [ text model ]
    ]
