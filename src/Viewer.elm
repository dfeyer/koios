module Viewer exposing (Viewer, cred, decoder, username)

import Api exposing (Cred)
import Json.Decode as Decode exposing (Decoder)
import Username exposing (Username)



-- TYPES


type Viewer
    = Viewer Cred



-- INFO


cred : Viewer -> Cred
cred (Viewer val) =
    val


username : Viewer -> Username
username (Viewer val) =
    Api.username val



-- SERIALIZATION


decoder : Decoder (Cred -> Viewer)
decoder =
    Decode.succeed Viewer


store : Viewer -> Cmd msg
store (Viewer credVal) =
    Api.storeCredWith
        credVal
