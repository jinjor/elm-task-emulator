module AudioContext exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import ScriptUtil


type alias AudioContext = Types.AudioContext


newAudioContext : PortTask x AudioContext
newAudioContext =
  ScriptUtil.new0 "AudioContext" decodeContext


newOfflineAudioContext : Int -> Int -> Float -> PortTask x AudioContext
newOfflineAudioContext =
  ScriptUtil.new3 "OfflineAudioContext" Encode.int Encode.int Encode.float decodeContext

--

currentTime : AudioContext -> PortTask x Float
currentTime = get "currentTime" Decode.float


destination : AudioContext -> PortTask x AudioNode
destination = get "destination" decodeNode


-- listener : AudioContext -> PortTask x AudioListener
-- listener (AudioContext context) =
--   ScriptUtil.get decodeListener context [ "listener" ]


sampleRate : AudioContext -> PortTask x Float
sampleRate = get "sampleRate" Decode.float


state : AudioContext -> PortTask x String
state = get "state" Decode.string

--

close : AudioContext -> PortTask x ()
close context =
  Script.successful decodeUnit [ encodeContext context ]
    "args[0].close().then(function() { succeed(); }, function(e) { fail(e); } )"


decodeAudioData : ArrayBuffer -> AudioContext -> PortTask x AudioBuffer
decodeAudioData buffer context =
  Script.successful decodeBuffer [ encodeContext context, encodeArrayBuffer buffer ]
    "args[0].decodeAudioData(args[1]).then(function(decodedData) { succeed(decodedData); }, function(e) { fail(e); } )"


resume : AudioContext -> PortTask x ()
resume context =
  Script.successful decodeUnit [ encodeContext context ]
    "args[0].resume().then(function() { succeed(); }, function(e) { fail(e); } )"


suspend : AudioContext -> PortTask x ()
suspend context =
  Script.successful decodeUnit [ encodeContext context ]
    "args[0].suspend().then(function() { succeed(); }, function(e) { throw e; } )"


startRendering : Decoder a -> AudioContext -> PortTask x a
startRendering decoder context =
  Script.successful decoder [ encodeContext context ]
    "args[0].startRendering().then(function(e) { succeed(e); }, function(e) { throw e; } )"


renderedBuffer : Decoder AudioBuffer
renderedBuffer =
  Decode.at ["renderedBuffer"] decodeBuffer


--

createBufferSource : AudioContext -> PortTask x AudioNode
createBufferSource = create "BufferSource"


-- Is it a good idea to createAudioNode from DOM nodes?
-- createMediaElementSource : HTMLMediaElement -> AudioContext -> PortTask x AudioNode
-- createMediaElementSource = create "MediaElementSource"


createMediaStreamSource : MediaStream -> AudioContext -> PortTask x AudioNode
createMediaStreamSource = create1 "MediaStreamSource" encodeMediaStream


createMediaStreamDestination : AudioContext -> PortTask x AudioNode
createMediaStreamDestination = create "MediaStreamDestination"


createScriptProcessor : AudioContext -> PortTask x AudioNode
createScriptProcessor = create "ScriptProcessor"


createStereoPanner : AudioContext -> PortTask x AudioNode
createStereoPanner = create "StereoPanner"


createAnalyzer : AudioContext -> PortTask x AudioNode
createAnalyzer = create "Analyzer"


createBiquadFilter : AudioContext -> PortTask x AudioNode
createBiquadFilter = create "BiquadFilter"


createChannerlMerger : AudioContext -> PortTask x AudioNode
createChannerlMerger = create "ChannerlMerger"


createChannerlSplitter : AudioContext -> PortTask x AudioNode
createChannerlSplitter = create "ChannerlSplitter"


createConvolver : AudioContext -> PortTask x AudioNode
createConvolver = create "Convolver"


createDelay : AudioContext -> PortTask x AudioNode
createDelay = create "Delay"


createDynamicsCompressor : AudioContext -> PortTask x AudioNode
createDynamicsCompressor = create "DynamicsCompressor"


createGain : AudioContext -> PortTask x AudioNode
createGain = create "Gain"


createIIRFilter : AudioContext -> PortTask x AudioNode
createIIRFilter = create "IIRFilter"


createOscillator : AudioContext -> PortTask x AudioNode
createOscillator = create "Oscillator"


createPanner : AudioContext -> PortTask x AudioNode
createPanner = create "Panner"


createWaveShaper : AudioContext -> PortTask x AudioNode
createWaveShaper = create "WaveShaper"


create : String -> AudioContext -> PortTask x AudioNode
create nodeName =
  ScriptUtil.f0 encodeContext ("create" ++ nodeName) decodeNode


create1 : String -> (a -> Json) -> (a -> AudioContext -> PortTask x AudioNode)
create1 nodeName encode =
  ScriptUtil.f1 encodeContext ("create" ++ nodeName) encode decodeNode

--

get : String -> Decoder a -> AudioContext -> PortTask x a
get = ScriptUtil.get encodeContext
