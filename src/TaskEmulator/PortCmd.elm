module TaskEmulator.PortCmd exposing (PortCmd(..), none)

import Json.Decode as Decode exposing (Decoder)


type alias Json = Decode.Value


type PortCmd msg
  = Simple (Cmd msg)
  | Callback Json (Json -> PortCmd msg)


none : PortCmd msg
none = Simple Cmd.none


map : (a -> b) -> PortCmd a -> PortCmd b
map f portCmd =
  case portCmd of
    Simple cmd ->
      Simple (Cmd.map f cmd)
    Callback json toCmd ->
      Callback json (map f << toCmd)
