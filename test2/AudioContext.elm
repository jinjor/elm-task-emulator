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
  ScriptUtil.new decodeContext [ "AudioContext" ] []

--

currentTime : AudioContext -> PortTask x Float
currentTime context =
  ScriptUtil.get decodeFloat (encodeContext context) [ "currentTime" ]


destination : AudioContext -> PortTask x AudioNode
destination context =
  ScriptUtil.get decodeNode (encodeContext context) [ "destination" ]


-- listener : AudioContext -> PortTask x AudioListener
-- listener (AudioContext context) =
--   ScriptUtil.get decodeListener context [ "listener" ]

sampleRate : AudioContext -> PortTask x Float
sampleRate context =
  ScriptUtil.get decodeFloat (encodeContext context) [ "sampleRate" ]


state : AudioContext -> PortTask x String
state context =
  ScriptUtil.get decodeString (encodeContext context) [ "state" ]



--

createBufferSource : AudioContext -> PortTask x AudioNode
createBufferSource = create "BufferSource"


createMediaElementSource : AudioContext -> PortTask x AudioNode
createMediaElementSource = create "MediaElementSource"


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
create nodeName (AudioContext context) =
  ScriptUtil.exec decodeNode context [ "create" ++ nodeName ] []
