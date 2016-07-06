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
context = get "context" decodeContext


numberOfOutputs : AudioNode -> PortTask x Int
numberOfOutputs = get "numberOfOutputs" Decode.int


numberOfInputs : AudioNode -> PortTask x Int
numberOfInputs = get "numberOfInputs" Decode.int


connect : AudioNode -> AudioNode -> PortTask x ()
connect = f1 "connect" encodeNode decodeUnit


disconnect : AudioNode -> PortTask x ()
disconnect = f0 "disconnect" decodeUnit


-- AnalyserNode


getFftSize : AudioNode -> PortTask x Int
getFftSize = get "fftSize" Decode.int


setFftSize : Int -> AudioNode -> PortTask x ()
setFftSize = set "fftSize" Encode.int


getFrequencyBinCount : AudioNode -> PortTask x Int
getFrequencyBinCount = get "frequencyBinCount" Decode.int


getMinDecibels : AudioNode -> PortTask x Float
getMinDecibels = get "minDecibels" Decode.float


setMinDecibels : Float -> AudioNode -> PortTask x ()
setMinDecibels = set "minDecibels" Encode.float


getMaxDecibels : AudioNode -> PortTask x Float
getMaxDecibels = get "maxDecibels" Decode.float


setMaxDecibels : Float -> AudioNode -> PortTask x ()
setMaxDecibels = set "maxDecibels" Encode.float


getSmoothingTimeConstant : AudioNode -> PortTask x Float
getSmoothingTimeConstant = get "smoothingTimeConstant" Decode.float


setSmoothingTimeConstant : Float -> AudioNode -> PortTask x ()
setSmoothingTimeConstant = set "smoothingTimeConstant" Encode.float


-- AudioBufferSourceNode

setBuffer : AudioBuffer -> AudioNode -> PortTask x ()
setBuffer = set "buffer" encodeBuffer


getBuffer : AudioNode -> PortTask x AudioBuffer
getBuffer = get "buffer" decodeBuffer


getDetune : AudioNode -> PortTask x AudioParam
getDetune = get "detune" decodeParam


getLoop : AudioNode -> PortTask x Bool
getLoop = get "loop" Decode.bool


setLoop : Bool -> AudioNode -> PortTask x ()
setLoop = set "loop" Encode.bool


getLoopStart : AudioNode -> PortTask x Float
getLoopStart = get "loopStart" Decode.float


setLoopStart : Float -> AudioNode -> PortTask x ()
setLoopStart = set "loopStart" Encode.float


getLoopEnd : AudioNode -> PortTask x Float
getLoopEnd = get "loopEnd" Decode.float


setLoopEnd : Float -> AudioNode -> PortTask x ()
setLoopEnd = set "loopEnd" Encode.float


getPlaybackRate : AudioNode -> PortTask x AudioParam
getPlaybackRate = get "playbackRate" decodeParam


-- StereoPannerNode

getPan : AudioNode -> PortTask x AudioParam
getPan = get "pan" decodeParam


-- BiquadFilterNode

-- setType (defined above)
-- setFrequencyValue (defined above)
-- setGainValue (defined above)
-- getDetune (defined above)


getQ : AudioNode -> PortTask x AudioParam
getQ = get "Q" decodeParam


-- ConvoluverNode

-- setBuffer (defined above) : AudioBuffer -> AudioNode -> PortTask x ()
-- getBuffer (defined above) : AudioNode -> PortTask x AudioBuffer


getNormalize : AudioNode -> PortTask x Bool
getNormalize = get "normalize" Decode.bool


setNormalize : Bool -> AudioNode -> PortTask x ()
setNormalize = set "normalize" Encode.bool


-- DelayNode

getDelayTime : AudioNode -> PortTask x AudioParam
getDelayTime = get "delayTime" decodeParam


-- DynamicsCompressorNode

getThreshold : AudioNode -> PortTask x AudioParam
getThreshold = get "threshold" decodeParam


getKnee : AudioNode -> PortTask x AudioParam
getKnee = get "knee" decodeParam


getRatio : AudioNode -> PortTask x AudioParam
getRatio = get "ratio" decodeParam


getAttack : AudioNode -> PortTask x AudioParam
getAttack = get "attack" decodeParam


getRelease : AudioNode -> PortTask x AudioParam
getRelease = get "release" decodeParam


-- reduction (float)


-- GainNode

getGain : AudioNode -> PortTask x AudioParam
getGain = get "gain" decodeParam


-- IIRFilterNode


-- OscillatorNode


start : AudioNode -> PortTask x ()
start = f0 "start" decodeUnit


stop : AudioNode -> PortTask x ()
stop = f0 "stop" decodeUnit


setType : String -> AudioNode -> PortTask x ()
setType = set "type" Encode.string


getFrequency : AudioNode -> PortTask x AudioParam
getFrequency = get "frequency" decodeParam

-- PannerNode

-- WaveShaperNode

-- AudioWorkerNode

-- DestinationNode


getMaxChannelCount : AudioNode -> PortTask x Int
getMaxChannelCount = get "maxChannelCount" Decode.int


setMaxChannelCount : Int -> AudioNode -> PortTask x ()
setMaxChannelCount = set "maxChannelCount" Encode.int


---

get : String -> Decoder a -> AudioNode -> PortTask x a
get = ScriptUtil.get encodeNode


set : String -> (a -> Json) -> a -> AudioNode -> PortTask x ()
set = ScriptUtil.set encodeNode


f0 : String -> Decoder a -> (AudioNode -> PortTask x a)
f0 = ScriptUtil.f0 encodeNode


f1 : String -> (arg0 -> Json) -> Decoder a -> (arg0 -> AudioNode -> PortTask x a)
f1 = ScriptUtil.f1 encodeNode


setParamValue : (AudioNode -> PortTask x AudioParam) -> Float -> AudioNode -> PortTask x ()
setParamValue getParam = \v -> (flip PortTask.andThen) (setValue v) << getParam

--
