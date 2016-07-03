module AudioParam exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import ScriptUtil


type alias AudioParam = Types.AudioParam


getValue : AudioParam -> PortTask x Float
getValue (AudioParam param) =
  ScriptUtil.get decodeFloat param [ "value" ]


setValue : Float -> AudioParam -> PortTask x ()
setValue = setFloat ["value"]


{-
var now=ctx.currentTime;
var m_attack=0, m_decay=0.5, m_sustain=0.3, m_release=0.5;
var c_attack=0.4, c_decay=0.3, c_sustain=0.7, c_release=0.4;

var modulatorRootValue=modulatorGain.gain.value;  // Attackの目標値をセット
modulatorGain.gain.cancelScheduledValues(0);      // スケジュールを全て解除
modulatorGain.gain.setValueAtTime(0.0, now);      // 今時点を音の出始めとする
modulatorGain.gain.linearRampToValueAtTime(modulatorRootValue, now + m_attack);
// ▲ rootValue0までm_attack秒かけて直線的に変化
modulatorGain.gain.linearRampToValueAtTime(m_sustain * modulatorRootValue, now + m_attack + m_decay);
// ▲ m_sustain * modulatorRootValueまでm_attack+m_decay秒かけて直線的に変化

var carrierRootValue=carrierGain.gain.value;      // Attackの目標値をセット
carrierGain.gain.cancelScheduledValues(0);        // スケジュールを全て解除
carrierGain.gain.setValueAtTime(0.0, now);        // 今時点を音の出始めとする
carrierGain.gain.linearRampToValueAtTime(carrierRootValue, now + c_attack);
// ▲ rootValue0までc_attack秒かけて直線的に変化
carrierGain.gain.linearRampToValueAtTime(c_sustain * carrierRootValue, now + c_attack + c_decay);
// ▲ c_sustain * carrierRootValueまでc_attack+c_decay秒かけて直線的に変化

-}



set : (a -> String) -> List String -> a -> AudioParam -> PortTask x ()
set toString at value (AudioParam param) =
  ScriptUtil.set toString param at value


setFloat : List String -> Float -> AudioParam -> PortTask x ()
setFloat = set toString
