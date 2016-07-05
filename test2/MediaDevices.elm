module MediaDevices exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)


getUserMedia : PortTask x MediaStream
getUserMedia =
  Script.create decodeMediaStream [] <|
    """( navigator.getUserMedia ||
         navigator.webkitGetUserMedia ||
         navigator.mozGetUserMedia ||
         navigator.msGetUserMedia)()
         .then(function(stream) { done(stream); }, function(e) { throw e; } )"""
