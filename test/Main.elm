port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)

import TaskEmulator.App as TaskEmulator

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Lib

type alias Json = Encode.Value

main =
  TaskEmulator.program input output
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


port input : TaskEmulator.Input msg

port output : TaskEmulator.Output msg


type Msg
  = Click
  | GotValue Int
  | Error String


type alias Model = String


init : (Model, Cmd Msg)
init = ("", Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg, PortCmd Msg)
update msg model =
  case Debug.log "msg" msg of
    Click ->
      ( model
      , Cmd.none
      , PortTask.perform
          Error
          GotValue
          (Lib.get10xValue 3 `PortTask.andThen` \i -> Lib.get10xValue i )
      )

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
