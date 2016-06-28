module TaskSim.Util.Script exposing (create)

import TaskSim.PortTaskInternal as PortTask exposing (PortTask)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

type alias Json = Decode.Value

create : (Json -> Result e a) -> (List Json) -> String -> PortTask e a
create decode args script =
  PortTask.create
  ( Encode.object
    [ ("args", Encode.list args)
    , ("script", Encode.string script)
    ]
  ) decode
