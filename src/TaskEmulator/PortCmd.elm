module TaskEmulator.PortCmd exposing (PortCmd, none)

import TaskEmulator.EffectManager as EM exposing (EffectManager)
import TaskEmulator.PortTask as PortTask

type alias PortCmd msg = EM.PortCmd msg


none : PortCmd msg
none = EM.Simple Cmd.none


map : (a -> b) -> PortCmd a -> PortCmd b
map f portCmd =
  case portCmd of
    EM.Simple cmd ->
      EM.Simple (Cmd.map f cmd)
    EM.Callback json toTask ->
      EM.Callback json (PortTask.mapError f << PortTask.map f << toTask)
