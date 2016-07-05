port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

import Task
import Basics.Extra exposing (never)
import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)

import TaskEmulator.App as TaskEmulator

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import AudioContext exposing (..)
import AudioNode exposing (..)

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
  = Init
  | Initialized (AudioContext, AudioNode, AudioNode, AudioNode)
  | Click
  | ShowInfo
  | Info String
  | Done

type alias Model =
  { playing : Bool
  , nodes : Maybe Nodes
  , info : String
  }

type alias Nodes =
  { audioContext : AudioContext
  , oscillator : AudioNode
  , gain : AudioNode
  , destination : AudioNode
  }


(>>=) = PortTask.andThen


init : (Model, Cmd Msg)
init = (Model False Nothing "", Task.perform never identity (Task.succeed Init))


update : Msg -> Model -> (Model, Cmd Msg, PortCmd Msg)
update msg model =
  case msg of
    Init ->
      ( model
      , Cmd.none
      , PortTask.perform never Initialized
          (newAudioContext >>= \context ->
           createOscillator context >>= \oscillator ->
           setType "square" oscillator >>= \_ ->
           setParamValue getFrequency 442 oscillator >>= \_ ->
           createGain context >>= \gain ->
           setParamValue getGain 0.3 gain >>= \_ ->
           destination context >>= \dest ->
           connect gain oscillator >>= \_ ->
           connect dest gain >>= \_ ->
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
              (stop oscillator)
          )
        (Just { oscillator }, False) ->
          ( { model | playing = True }
          , Cmd.none
          , PortTask.perform never (always Done)
              (start oscillator)
          )
        _ ->
          ( model, Cmd.none, PortCmd.none)
    ShowInfo ->
      let
        portCmd =
          case model.nodes of
            Just { oscillator, gain, destination } ->
              PortTask.perform never Info
                ( numberOfInputs oscillator >>= \inputs1 ->
                  numberOfOutputs oscillator >>= \outputs1 ->
                  numberOfInputs gain >>= \inputs2 ->
                  numberOfOutputs gain >>= \outputs2 ->
                  numberOfInputs destination >>= \inputs3 ->
                  numberOfOutputs destination >>= \outputs3 ->
                  PortTask.succeed
                    ( "oscillator: " ++ toString inputs1 ++ ", " ++ toString outputs1 ++ "\n" ++
                      "gain: " ++ toString inputs2 ++ ", " ++ toString outputs2 ++ "\n" ++
                      "destination: " ++ toString inputs3 ++ ", " ++ toString outputs3
                    )
                )
            _ -> PortCmd.none
      in
        ( model, Cmd.none, portCmd )
    Info s ->
      ( { model | info = s }, Cmd.none, PortCmd.none )
    Done ->
      ( model, Cmd.none, PortCmd.none )


subscriptions : Model -> Sub Msg
subscriptions = always Sub.none


view : Model -> Html Msg
view model =
  case model.nodes of
    Just _ ->
      div []
        [ button
          [ onClick Click ]
          [ text <| if model.playing then "Stop" else "Start" ]
        , button
          [ onClick ShowInfo ]
          [ text "Info" ]
        , pre [] [ text model.info ]
        ]

    Nothing ->
      text ""
