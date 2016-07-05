module Types exposing (..)

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Encode.Value

type AudioContext = AudioContext Json

type AudioNode = AudioNode Json

type AudioParam = AudioParam Json

type AudioBuffer = AudioBuffer Json

type Float32Array = Float32Array Json

type ArrayBuffer = ArrayBuffer Json

type MediaStream = MediaStream Json


decodeContext : Decoder AudioContext
decodeContext =
  Decode.customDecoder Decode.value (Ok << AudioContext)


decodeNode : Decoder AudioNode
decodeNode =
  Decode.customDecoder Decode.value (Ok << AudioNode)


decodeParam : Decoder AudioParam
decodeParam =
  Decode.customDecoder Decode.value (Ok << AudioParam)


decodeBuffer : Decoder AudioBuffer
decodeBuffer =
  Decode.customDecoder Decode.value (Ok << AudioBuffer)


decodeFloat32Array : Decoder Float32Array
decodeFloat32Array =
  Decode.customDecoder Decode.value (Ok << Float32Array)


decodeArrayBuffer : Decoder ArrayBuffer
decodeArrayBuffer =
  Decode.customDecoder Decode.value (Ok << ArrayBuffer)


decodeMediaStream : Decoder MediaStream
decodeMediaStream =
  Decode.customDecoder Decode.value (Ok << MediaStream)


decodeUnit : Decoder ()
decodeUnit =
  Decode.succeed ()


---

encodeContext : AudioContext -> Json
encodeContext (AudioContext json) = json


encodeNode : AudioNode -> Json
encodeNode (AudioNode json) = json


encodeParam : AudioParam -> Json
encodeParam (AudioParam json) = json


encodeBuffer : AudioBuffer -> Json
encodeBuffer (AudioBuffer json) = json


encodeFloat32Array : Float32Array -> Json
encodeFloat32Array (Float32Array json) = json


encodeArrayBuffer : ArrayBuffer -> Json
encodeArrayBuffer (ArrayBuffer json) = json


encodeMediaStream : MediaStream -> Json
encodeMediaStream (MediaStream json) = json


encodeMaybe : (a -> Json) -> Maybe a -> Json
encodeMaybe toJson maybe =
  case maybe of
    Just a -> toJson a
    Nothing -> Encode.null
