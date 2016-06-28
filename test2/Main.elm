port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

import Task
import Basics.Extra exposing (never)
import TaskSim.PortTask as PortTask exposing (PortTask)
import TaskSim.PortCmd as PortCmd exposing (PortCmd)

import TaskSim.App as TaskSim

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Lib exposing (..)

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
  = Init
  | Initialized (AudioContext, AudioNode, AudioNode, AudioNode)
  | Click
  | Done

type alias Model =
  { playing : Bool
  , nodes : Maybe Nodes
  }

type alias Nodes =
  { audioContext : AudioContext
  , oscillator : AudioNode
  , gain : AudioNode
  , destination : AudioNode
  }


(>>=) = PortTask.andThen


init : (Model, Cmd Msg)
init = (Model False Nothing, Task.perform never identity (Task.succeed Init))


update : Msg -> Model -> (Model, Cmd Msg, PortCmd Msg)
update msg model =
  case msg of
    Init ->
      ( model
      , Cmd.none
      , PortTask.perform never Initialized
          (newAudioContext >>= \context ->
           createOscillator context >>= \oscillator ->
           setString oscillator ["type"] "square" >>= \_ ->
           setInt oscillator ["frequency", "value"] 442 >>= \_ ->
           createGain context >>= \gain ->
           destination context >>= \dest ->
           connect oscillator gain >>= \_ ->
           connect gain dest >>= \_ ->
           PortTask.succeed (context, oscillator, gain, dest)
          )
      )
    Initialized (context, oscillator, gain, dest) ->
      ( { model | nodes = Just (Nodes context oscillator gain dest) }
      , Cmd.none
      , PortCmd.none
      )
    Click ->
      case (model.nodes, model.playing) of
        (Just { oscillator }, True) ->
          ( { model | playing = False }
          , Cmd.none
          , PortTask.perform never (always Done)
              (exec oscillator ["stop"])
          )
        (Just { oscillator }, False) ->
          ( { model | playing = True }
          , Cmd.none
          , PortTask.perform never (always Done)
              (exec oscillator ["start"])
          )
        _ ->
          ( model, Cmd.none, PortCmd.none)
    Done ->
      ( model, Cmd.none, PortCmd.none)


subscriptions : Model -> Sub Msg
subscriptions = always Sub.none


view : Model -> Html Msg
view model =
  case model.nodes of
    Just _ ->
      button
        [ onClick Click ]
        [ text <| if model.playing then "Stop" else "Go" ]
    Nothing ->
      text ""
