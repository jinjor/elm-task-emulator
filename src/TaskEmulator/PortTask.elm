module TaskEmulator.PortTask exposing
  ( PortTask
  , create
  , succeed
  , fail
  , map
  , mapError
  , andThen
  , perform
  )

import Json.Decode as Decode exposing (Decoder)
import TaskEmulator.PortTaskInternal as T
import TaskEmulator.EffectManager as EM

type alias Json = Decode.Value

type alias PortTask e a = T.PortTask e a

create : Json -> (Json -> Result e a) -> PortTask e a
create = T.create


succeed : a -> PortTask e a
succeed = T.succeed


fail : e -> PortTask e a
fail = T.Fail


map : (a -> b) -> PortTask e a -> PortTask e b
map = T.map


mapError : (e1 -> e2) -> PortTask e1 a -> PortTask e2 a
mapError = T.mapError


andThen : PortTask e a -> (a -> PortTask e b) -> PortTask e b
andThen = T.andThen


perform : (e -> msg) -> (a -> msg) -> PortTask e a -> EM.PortCmd msg
perform = EM.perform
