module TaskSim.PortTaskInternal exposing (..)

import Json.Decode as Decode exposing (Decoder)

type alias Json = Decode.Value

type PortTask e a
  = Task
    { data : Json
    , decode : Json -> PortTask e a
    }
  | Succeed a
  | Fail e


create : Json -> (Json -> Result e a) -> PortTask e a
create data decode =
  Task
    { data = data
    , decode =
      (\j -> case decode j of
        Ok a -> Succeed a
        Err e -> Fail e
      )
    }


succeed : a -> PortTask e a
succeed = Succeed


fail : e -> PortTask e a
fail = Fail


map : (a -> b) -> PortTask e a -> PortTask e b
map f task =
  case task of
    Task { data, decode } ->
      Task { data = data, decode = (map f) << decode }
    Succeed a -> Succeed (f a)
    Fail e -> Fail e


mapError : (e1 -> e2) -> PortTask e1 a -> PortTask e2 a
mapError f task =
  case task of
    Task { data, decode } ->
      Task { data = data, decode = (mapError f) << decode }
    Succeed a -> Succeed a
    Fail e -> Fail (f e)


andThen : PortTask e a -> (a -> PortTask e b) -> PortTask e b
andThen task f =
  case task of
    Task { data, decode } ->
      Task { data = data, decode = (flip andThen f) << decode }
    Succeed a -> f a
    Fail e -> Fail e
