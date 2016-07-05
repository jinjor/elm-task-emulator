module TaskEmulator.Util.Script exposing (create, successful)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Decode.Value

-- create : (Json -> Result e a) -> (List Json) -> String -> PortTask e a
-- create decode args script =
--   PortTask.create
--   ( Encode.object
--     [ ("args", Encode.list args)
--     , ("script", Encode.string script)
--     ]
--   ) decode


create : Decoder e -> Decoder a -> (List Json) -> String -> PortTask e a
create decodeError =
  create' (Just decodeError)

successful : Decoder a -> (List Json) -> String -> PortTask e a
successful =
  create' Nothing


create' : Maybe (Decoder e) -> Decoder a -> (List Json) -> String -> PortTask e a
create' decodeError decodeData args script =
  PortTask.create
  ( Encode.object
    [ ("args", Encode.list args)
    , ("script", Encode.string script)
    ]
  ) (customDecoder decodeError decodeData)


customDecoder : Maybe (Decoder e) -> Decoder a -> (Json -> Result e a)
customDecoder decodeError decodeData = \json ->
  let
    decoder =
      Decode.customDecoder
      ( Decode.oneOf
          [ Decode.tuple2 (,) (Decode.null Nothing) Decode.value
          , Decode.tuple2 (,) (Decode.map Just Decode.value) Decode.value
          ]
      )
      (\(err, data) ->
        case err of
          Just e ->
            case decodeError of
              Just decode ->
                case Decode.decodeValue decode e of
                  Ok e -> Ok (Err e)
                  Err s -> Debug.log "0" <| Err s
              Nothing ->
                Err ("No error handler defined") -- TODO toString, but avoid infinite loop
          Nothing ->
            case Decode.decodeValue decodeData data of
              Ok a -> Ok (Ok a)
              Err s -> Debug.log "1" <| Err s
      )
  in
    case Decode.decodeValue decoder json of
      Ok result -> result
      Err s -> Debug.crash s
