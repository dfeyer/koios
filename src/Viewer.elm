module Viewer exposing (Viewer, cred, decoder, store, username, viewer)

import Api exposing (Cred)
import Json.Decode as Decode exposing (Decoder)
import Username exposing (Username, createUsername)



-- TYPES


type Viewer
    = Viewer Cred


viewer : Cred -> Viewer
viewer c =
    Viewer c



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
