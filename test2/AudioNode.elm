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


getContext : AudioNode -> PortTask x AudioContext
getContext = get "context" decodeContext


getNumberOfInputs : AudioNode -> PortTask x Int
getNumberOfInputs = get "numberOfInputs" Decode.int


getNumberOfOutputs : AudioNode -> PortTask x Int
getNumberOfOutputs = get "numberOfOutputs" Decode.int


getChannelCount : AudioNode -> PortTask x Int
getChannelCount = get "channelCount" Decode.int


setChannelCount : Int -> AudioNode -> PortTask x ()
setChannelCount = set "channelCount" Encode.int


getChannelCountMode : AudioNode -> PortTask x String
getChannelCountMode = get "channelCountMode" Decode.string


setChannelCountMode : String -> AudioNode -> PortTask x ()
setChannelCountMode = set "channelCountMode" Encode.string


getChannelInterpretation : AudioNode -> PortTask x String
getChannelInterpretation = get "channelInterpretation" Decode.string


setChannelInterpretation : String -> AudioNode -> PortTask x ()
setChannelInterpretation = set "channelInterpretation" Encode.string


connect : AudioNode -> AudioNode -> PortTask x ()
connect = f1 "connect" encodeNode decodeUnit


connectToParam : AudioParam -> AudioNode -> PortTask x ()
connectToParam = f1 "connect" encodeParam decodeUnit


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


setDetune : AudioParam -> AudioNode -> PortTask x ()
setDetune = set "detune" encodeParam


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

-- getFrequency (defined above)
-- setFrequency (defined above)

-- getDetune (defined above)
-- setDetune (defined above)

getQ : AudioNode -> PortTask x AudioParam
getQ = get "Q" decodeParam


setQ : AudioParam -> AudioNode -> PortTask x ()
setQ = set "Q" encodeParam

-- getGain (defined above)

-- getType (defined above)
-- setType (defined above)


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


-- GainNode

getGain : AudioNode -> PortTask x AudioParam
getGain = get "gain" decodeParam


-- IIRFilterNode


-- OscillatorNode

getFrequency : AudioNode -> PortTask x AudioParam
getFrequency = get "frequency" decodeParam


setFrequency : AudioParam -> AudioNode -> PortTask x ()
setFrequency = set "frequency" encodeParam


getType : AudioNode -> PortTask x String
getType = get "type" Decode.string


setType : String -> AudioNode -> PortTask x ()
setType = set "type" Encode.string


-- getDetune (defined above) : AudioNode -> PortTask x AudioParam

-- setDetune (defined above) : AudioParam -> AudioNode -> PortTask x ()


start : AudioNode -> PortTask x ()
start = f0 "start" decodeUnit


stop : AudioNode -> PortTask x ()
stop = f0 "stop" decodeUnit


setPeriodicWave : PeriodicWave -> AudioNode -> PortTask x ()
setPeriodicWave = f1 "setPeriodicWave" encodePeriodicWave decodeUnit



-- PannerNode

getPanningModel : AudioNode -> PortTask x String
getPanningModel = get "panningModel" Decode.string


setPanningModel : String -> AudioNode -> PortTask x ()
setPanningModel = set "panningModel" Encode.string


getDistanceModel : AudioNode -> PortTask x String
getDistanceModel = get "distanceModel" Decode.string


setDistanceModel : String -> AudioNode -> PortTask x ()
setDistanceModel = set "distanceModel" Encode.string


getRefDistance : AudioNode -> PortTask x Float
getRefDistance = get "refDistance" Decode.float


setRefDistance : Float -> AudioNode -> PortTask x ()
setRefDistance = set "refDistance" Encode.float


getMaxDistance : AudioNode -> PortTask x Float
getMaxDistance = get "maxDistance" Decode.float


setMaxDistance : Float -> AudioNode -> PortTask x ()
setMaxDistance = set "maxDistance" Encode.float


getRolloffFactor : AudioNode -> PortTask x Float
getRolloffFactor = get "rolloffFactor" Decode.float


setRolloffFactor : Float -> AudioNode -> PortTask x ()
setRolloffFactor = set "rolloffFactor" Encode.float


getConeInnerAngle : AudioNode -> PortTask x Float
getConeInnerAngle = get "coneInnerAngle" Decode.float


setConeInnerAngle : Float -> AudioNode -> PortTask x ()
setConeInnerAngle = set "coneInnerAngle" Encode.float


getConeOuterAngle : AudioNode -> PortTask x Float
getConeOuterAngle = get "coneOuterAngle" Decode.float


setConeOuterAngle : Float -> AudioNode -> PortTask x ()
setConeOuterAngle = set "coneOuterAngle" Encode.float


getConeOuterGain : AudioNode -> PortTask x Float
getConeOuterGain = get "coneOuterGain" Decode.float


setConeOuterGain : Float -> AudioNode -> PortTask x ()
setConeOuterGain = set "coneOuterGain" Encode.float


-- WaveShaperNode


getCurve : AudioNode -> PortTask x Float32Array
getCurve = get "curve" decodeFloat32Array


setCurve : Float32Array -> AudioNode -> PortTask x ()
setCurve = set "curve" encodeFloat32Array


getOversample : AudioNode -> PortTask x String
getOversample = get "oversample" Decode.string


setOversample : String -> AudioNode -> PortTask x ()
setOversample = set "oversample" Encode.string

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
