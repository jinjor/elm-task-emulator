module TaskEmulator.App exposing (Input, Output, program)

import Html exposing (Html)
import Html.App as App

import Json.Decode as Decode exposing (Decoder)

import TaskEmulator.EffectManager as EffectManager exposing (..)

type alias Json = Decode.Value

type Msg msg
  = UserMsg msg
  | Input (Int, Json)
  | NoOp


type alias Model model msg =
  { userModel : model
  , effectManager : EffectManager msg
  }


type alias Input msg = ((Int, Json) -> msg) -> Sub msg

type alias Output msg = (Int, Json) -> Cmd msg



program :
     (((Int, Json) -> (Msg msg)) -> Sub (Msg msg))
  -> ((Int, Json) -> Cmd msg)
  -> { init : (model, Cmd msg)
     , update : msg -> model -> (model, Cmd msg, PortCmd msg)
     , subscriptions : model -> Sub msg
     , view : model -> Html msg
     }
  -> Program Never
program input output { init, update, subscriptions, view } =
  let
    manager =
      EffectManager.init output

    init' =
      let
        (userModel, cmd) = init
      in
        ( { userModel = userModel, effectManager = manager }
        , Cmd.map UserMsg cmd
        )

    updateHelp m model =
      let
        (newUserModel, cmd, portCmd) =
          update m model.userModel

        (cmd2, newManager) =
          execPortCmd portCmd model.effectManager
      in
        { model
        | userModel = newUserModel
        , effectManager = newManager
        } ! [ Cmd.map UserMsg cmd, Cmd.map UserMsg cmd2 ]

    update' msg model =
      case msg of
        UserMsg m ->
          updateHelp m model
        Input (id, data) ->
          let
            (cmd, newManager) =
              EffectManager.transformInput (id, data) model.effectManager
          in
            { model | effectManager = newManager } ! [ Cmd.map UserMsg cmd ]
        NoOp ->
          model ! []

    subscriptions' model =
      Sub.batch
        [ Sub.map UserMsg (subscriptions model.userModel)
        , input Input
        ]

    view' { userModel } =
      App.map UserMsg (view userModel)
  in
    App.program { init = init', update = update', subscriptions = subscriptions', view = view' }
