module TaskSim.PortCmd exposing (PortCmd, none)

import TaskSim.EffectManager as EM exposing (EffectManager)

type alias PortCmd msg = EM.PortCmd msg

none : PortCmd msg
none = \a -> (Cmd.none, a)
