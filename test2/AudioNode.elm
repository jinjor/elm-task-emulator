module AudioNode exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import ScriptUtil
import AudioParam exposing (setValue)

type alias AudioNode = Types.AudioNode


context : AudioNode -> PortTask x AudioContext
context = getContext ["context"]


numberOfOutputs : AudioNode -> PortTask x Int
numberOfOutputs = getInt ["numberOfOutputs"]


numberOfInputs : AudioNode -> PortTask x Int
numberOfInputs = getInt ["numberOfInputs"]


connect : AudioNode -> AudioNode -> PortTask x ()
connect (AudioNode src) (AudioNode dest) =
  ScriptUtil.exec decodeUnit src ["connect"] [dest]


disconnect : AudioNode -> PortTask x ()
disconnect = exec ["disconnect"] []


-- StereoPannerNode

getPan : AudioNode -> PortTask x AudioParam
getPan = getParam "pan"


-- BiquadFilterNode


-- setType (defined above)
-- setFrequencyValue (defined above)
-- setGainValue (defined above)


getDetune : AudioNode -> PortTask x AudioParam
getDetune = getParam "detune"


getQ : AudioNode -> PortTask x AudioParam
getQ = getParam "Q"


-- DelayNode

getDelayTime : AudioNode -> PortTask x AudioParam
getDelayTime = getParam "delayTime"


-- DynamicsCompressorNode

getThreshold : AudioNode -> PortTask x AudioParam
getThreshold = getParam "threshold"


getKnee : AudioNode -> PortTask x AudioParam
getKnee = getParam "knee"


getRatio : AudioNode -> PortTask x AudioParam
getRatio = getParam "ratio"


getAttack : AudioNode -> PortTask x AudioParam
getAttack = getParam "attack"


getRelease : AudioNode -> PortTask x AudioParam
getRelease = getParam "release"


-- reduction (float)


-- GainNode

getGain : AudioNode -> PortTask x AudioParam
getGain = getParam "gain"


-- IIRFilterNode


-- OscillatorNode


start : AudioNode -> PortTask x ()
start = exec ["start"] []


stop : AudioNode -> PortTask x ()
stop = exec ["stop"] []


setType : String -> AudioNode -> PortTask x ()
setType = setString ["type"]


getFrequency : AudioNode -> PortTask x AudioParam
getFrequency = getParam "frequency"

-- PannerNode

-- WaveShaperNode

-- AudioWorkerNode


---

get : (Json -> Result x a) -> List String -> AudioNode -> PortTask x a
get decoder at (AudioNode node) =
  ScriptUtil.get decoder node at


getInt : List String -> AudioNode -> PortTask x Int
getInt = get decodeInt


getNode : List String -> AudioNode -> PortTask x AudioNode
getNode = get decodeNode


getParam : String -> AudioNode -> PortTask x AudioParam
getParam name = get decodeParam [name]


getContext : List String -> AudioNode -> PortTask x AudioContext
getContext = get decodeContext


set : (a -> String) -> List String -> a -> AudioNode -> PortTask x ()
set toString at value (AudioNode node) =
  ScriptUtil.set toString node at value


setInt : List String -> Int -> AudioNode -> PortTask x ()
setInt = set toString


setFloat : List String -> Float -> AudioNode -> PortTask x ()
setFloat = set toString


setString : List String -> String -> AudioNode -> PortTask x ()
setString = set (\s -> "'" ++ s ++ "'") -- TODO escape


exec : List String -> List Json -> AudioNode -> PortTask x ()
exec at args (AudioNode node) =
  ScriptUtil.execUnit node at args


setParamValue : (AudioNode -> PortTask x AudioParam) -> Float -> AudioNode -> PortTask x ()
setParamValue getParam = \v -> (flip PortTask.andThen) (setValue v) << getParam

--
