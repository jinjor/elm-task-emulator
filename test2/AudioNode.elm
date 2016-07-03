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
context = getContext "context"


numberOfOutputs : AudioNode -> PortTask x Int
numberOfOutputs = getInt "numberOfOutputs"


numberOfInputs : AudioNode -> PortTask x Int
numberOfInputs = getInt "numberOfInputs"


connect : AudioNode -> AudioNode -> PortTask x ()
connect (AudioNode src) (AudioNode dest) =
  ScriptUtil.exec decodeUnit src ["connect"] [dest]


disconnect : AudioNode -> PortTask x ()
disconnect = exec "disconnect" []


-- AnaliserNode

getFftSize : AudioNode -> PortTask x Int
getFftSize = getInt "fftSize"


setFftSize : Int -> AudioNode -> PortTask x ()
setFftSize = setInt "fftSize"


getFrequencyBinCount : AudioNode -> PortTask x Int
getFrequencyBinCount = getInt "frequencyBinCount"


getMinDecibels : AudioNode -> PortTask x Float
getMinDecibels = getFloat "minDecibels"


setMinDecibels : Float -> AudioNode -> PortTask x ()
setMinDecibels = setFloat "minDecibels"


getMaxDecibels : AudioNode -> PortTask x Float
getMaxDecibels = getFloat "maxDecibels"


setMaxDecibels : Float -> AudioNode -> PortTask x ()
setMaxDecibels = setFloat "maxDecibels"


getSmoothingTimeConstant : AudioNode -> PortTask x Float
getSmoothingTimeConstant = getFloat "smoothingTimeConstant"


setSmoothingTimeConstant : Float -> AudioNode -> PortTask x ()
setSmoothingTimeConstant = setFloat "smoothingTimeConstant"


-- AudioBufferSourceNode


-- getBuffer
-- setBuffer
-- (AudioBuffer)


getDetune : AudioNode -> PortTask x AudioParam
getDetune = getParam "detune"


getLoop : AudioNode -> PortTask x Bool
getLoop = getBool "loop"


setLoop : Bool -> AudioNode -> PortTask x ()
setLoop = setBool "loop"


getLoopStart : AudioNode -> PortTask x Float
getLoopStart = getFloat "loopStart"


setLoopStart : Float -> AudioNode -> PortTask x ()
setLoopStart = setFloat "loopStart"


getLoopEnd : AudioNode -> PortTask x Float
getLoopEnd = getFloat "loopEnd"


setLoopEnd : Float -> AudioNode -> PortTask x ()
setLoopEnd = setFloat "loopEnd"


getPlaybackRate : AudioNode -> PortTask x AudioParam
getPlaybackRate = getParam "playbackRate"


-- StereoPannerNode

getPan : AudioNode -> PortTask x AudioParam
getPan = getParam "pan"


-- BiquadFilterNode


-- setType (defined above)
-- setFrequencyValue (defined above)
-- setGainValue (defined above)
-- getDetune (defined above)


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
start = exec "start" []


stop : AudioNode -> PortTask x ()
stop = exec "stop" []


setType : String -> AudioNode -> PortTask x ()
setType = setString "type"


getFrequency : AudioNode -> PortTask x AudioParam
getFrequency = getParam "frequency"

-- PannerNode

-- WaveShaperNode

-- AudioWorkerNode


---

get : (Json -> Result x a) -> String -> AudioNode -> PortTask x a
get decoder at node =
  ScriptUtil.get decoder (encodeNode node) [at]


getInt : String -> AudioNode -> PortTask x Int
getInt = get decodeInt


getFloat : String -> AudioNode -> PortTask x Float
getFloat = get decodeFloat


getBool : String -> AudioNode -> PortTask x Bool
getBool = get decodeBool


getNode : String -> AudioNode -> PortTask x AudioNode
getNode = get decodeNode


getParam : String -> AudioNode -> PortTask x AudioParam
getParam = get decodeParam


getContext : String -> AudioNode -> PortTask x AudioContext
getContext = get decodeContext


set : (a -> Json) -> String -> a -> AudioNode -> PortTask x ()
set encode at value node =
  ScriptUtil.set encode (encodeNode node) [at] value


setInt : String -> Int -> AudioNode -> PortTask x ()
setInt = set Encode.int


setFloat : String -> Float -> AudioNode -> PortTask x ()
setFloat = set Encode.float


setBool : String -> Bool -> AudioNode -> PortTask x ()
setBool = set Encode.bool


setString : String -> String -> AudioNode -> PortTask x ()
setString = set Encode.string


exec : String -> List Json -> AudioNode -> PortTask x ()
exec at args node =
  ScriptUtil.execUnit (encodeNode node) [at] args


setParamValue : (AudioNode -> PortTask x AudioParam) -> Float -> AudioNode -> PortTask x ()
setParamValue getParam = \v -> (flip PortTask.andThen) (setValue v) << getParam

--
