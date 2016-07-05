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
import AudioBuffer


type alias AudioNode = Types.AudioNode


context : AudioNode -> PortTask x AudioContext
context = getContext "context"


numberOfOutputs : AudioNode -> PortTask x Int
numberOfOutputs = getInt "numberOfOutputs"


numberOfInputs : AudioNode -> PortTask x Int
numberOfInputs = getInt "numberOfInputs"


connect : AudioNode -> AudioNode -> PortTask x ()
connect = f1 "connect" encodeNode decodeUnit


disconnect : AudioNode -> PortTask x ()
disconnect = f0 "disconnect" decodeUnit


-- AnalyserNode


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

setBuffer : AudioBuffer -> AudioNode -> PortTask x ()
setBuffer = setAudioBuffer "buffer"


getBuffer : AudioNode -> PortTask x AudioBuffer
getBuffer = getAudioBuffer "buffer"


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


-- ConvoluverNode

-- setBuffer (defined above) : AudioBuffer -> AudioNode -> PortTask x ()
-- getBuffer (defined above) : AudioNode -> PortTask x AudioBuffer


getNormalize : AudioNode -> PortTask x Bool
getNormalize = getBool "normalize"


setNormalize : Bool -> AudioNode -> PortTask x ()
setNormalize = setBool "normalize"


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
start = f0 "start" decodeUnit


stop : AudioNode -> PortTask x ()
stop = f0 "stop" decodeUnit


setType : String -> AudioNode -> PortTask x ()
setType = setString "type"


getFrequency : AudioNode -> PortTask x AudioParam
getFrequency = getParam "frequency"

-- PannerNode

-- WaveShaperNode

-- AudioWorkerNode

-- DestinationNode


getMaxChannelCount : AudioNode -> PortTask x Int
getMaxChannelCount = getInt "maxChannelCount"


setMaxChannelCount : Int -> AudioNode -> PortTask x ()
setMaxChannelCount = setInt "maxChannelCount"


---

get : Decoder a -> String -> AudioNode -> PortTask x a
get decoder at node =
  ScriptUtil.get decoder (encodeNode node) at


getInt : String -> AudioNode -> PortTask x Int
getInt = get Decode.int


getFloat : String -> AudioNode -> PortTask x Float
getFloat = get Decode.float


getBool : String -> AudioNode -> PortTask x Bool
getBool = get Decode.bool


getNode : String -> AudioNode -> PortTask x AudioNode
getNode = get decodeNode


getParam : String -> AudioNode -> PortTask x AudioParam
getParam = get decodeParam


getContext : String -> AudioNode -> PortTask x AudioContext
getContext = get decodeContext


getAudioBuffer : String -> AudioNode -> PortTask x AudioBuffer
getAudioBuffer = get decodeBuffer


set : (a -> Json) -> String -> a -> AudioNode -> PortTask x ()
set encode at value node =
  ScriptUtil.set encode (encodeNode node) at value


setInt : String -> Int -> AudioNode -> PortTask x ()
setInt = set Encode.int


setFloat : String -> Float -> AudioNode -> PortTask x ()
setFloat = set Encode.float


setBool : String -> Bool -> AudioNode -> PortTask x ()
setBool = set Encode.bool


setString : String -> String -> AudioNode -> PortTask x ()
setString = set Encode.string


setAudioBuffer : String -> AudioBuffer -> AudioNode -> PortTask x ()
setAudioBuffer = set encodeBuffer


f0 : String -> Decoder a -> (AudioNode -> PortTask x a)
f0 = ScriptUtil.f0 encodeNode


f1 : String -> (arg0 -> Json) -> Decoder a -> (arg0 -> AudioNode -> PortTask x a)
f1 = ScriptUtil.f1 encodeNode


setParamValue : (AudioNode -> PortTask x AudioParam) -> Float -> AudioNode -> PortTask x ()
setParamValue getParam = \v -> (flip PortTask.andThen) (setValue v) << getParam

--
