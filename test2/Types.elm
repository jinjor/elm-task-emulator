module Types exposing (..)

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Encode.Value

type AudioContext = AudioContext Json

type AudioNode = AudioNode Json

type AudioParam = AudioParam Json


decodeContext : Json -> Result x AudioContext
decodeContext node =
  Ok (AudioContext node)


decodeNode : Json -> Result x AudioNode
decodeNode node =
  Ok (AudioNode node)


decodeParam : Json -> Result x AudioParam
decodeParam param =
  Ok (AudioParam param)


decodeUnit : Json -> Result x ()
decodeUnit _ =
  Ok ()


decodeInt : Json -> Result x Int
decodeInt json =
  case Decode.decodeValue Decode.int json of
    Ok v -> Ok v
    _ -> Debug.crash ("not int: " ++ toString json)


decodeFloat : Json -> Result x Float
decodeFloat json =
  case Decode.decodeValue Decode.float json of
    Ok v -> Ok v
    _ -> Debug.crash ("not float: " ++ toString json)


decodeBool : Json -> Result x Bool
decodeBool json =
  case Decode.decodeValue Decode.bool json of
    Ok v -> Ok v
    _ -> Debug.crash ("not bool: " ++ toString json)


decodeString : Json -> Result x String
decodeString json =
  case Decode.decodeValue Decode.string json of
    Ok v -> Ok v
    _ -> Debug.crash ("not string: " ++ toString json)



encodeContext : AudioContext -> Json
encodeContext (AudioContext json) = json


encodeNode : AudioNode -> Json
encodeNode (AudioNode json) = json


encodeParam : AudioParam -> Json
encodeParam (AudioParam json) = json
