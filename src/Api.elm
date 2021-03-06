port module Api exposing (Cred, application, login, logout, storageDecoder, storeCredWith, token, username, viewerChanges)

{-| The authentication credentials for the Viewer (that is, the currently logged-in user.)
This includes:

  - The cred's Username
  - The cred's authentication token
    By design, there is no way to access the token directly as a String.
    It can be encoded for persistence, and it can be added to a header
    to a HttpBuilder for a request, but that's it.
    This token should never be rendered to the end user, and with this API, it
    can't be!

-}

-- CRED

import Browser
import Browser.Navigation as Nav
import Http exposing (jsonBody)
import Json.Decode as Decode exposing (Decoder, Value, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import RemoteData exposing (RemoteData, WebData)
import Request.Auth exposing (AuthParameters, AuthResponse, Endpoint, authEndpoint, authParametersEncoder, endpoint, endpointToString)
import Url exposing (Url)
import Username exposing (Username)


type alias Token =
    String


type Cred
    = Cred Username Token


username : Cred -> Username
username (Cred value _) =
    value


token : Cred -> Token
token (Cred _ value) =
    value


{-| It's important that this is never exposed!
We epxose `login` and `application` instead, so we can be certain that if anyone
ever has access to a `Cred` value, it came from either the login API endpoint
or was passed in via flags.
-}
credDecoder : Username -> Decoder Cred
credDecoder u =
    Decode.succeed (Cred u)
        |> required "token" string


storedCredDecoder : Decoder Cred
storedCredDecoder =
    Decode.succeed Cred
        |> required "username" Username.decoder
        |> required "token" string



-- PERSISTENCE


decode : Decoder (Cred -> viewer) -> Value -> Result Decode.Error viewer
decode decoder value =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    Decode.decodeValue Decode.string value
        |> Result.andThen (\str -> Decode.decodeString (Decode.field "user" (decoderFromCred decoder)) str)


port onStoreChange : (Value -> msg) -> Sub msg


viewerChanges : (Maybe viewer -> msg) -> Decoder (Cred -> viewer) -> Sub msg
viewerChanges toMsg decoder =
    onStoreChange (\value -> toMsg (decodeFromChange decoder value))


decodeFromChange : Decoder (Cred -> a) -> Value -> Maybe a
decodeFromChange viewerDecoder val =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    Decode.decodeValue (storageDecoder viewerDecoder) val
        |> Result.toMaybe


storeCredWith : Cred -> Cmd msg
storeCredWith (Cred u t) =
    let
        json =
            Encode.object
                [ ( "user"
                  , Encode.object
                        [ ( "username", Username.encode u )
                        , ( "token", Encode.string t )
                        ]
                  )
                ]
    in
    storeCache (Just json)


login : (WebData Cred -> msg) -> AuthParameters -> Cmd msg
login msg options =
    Http.post
        { url =
            endpointToString authEndpoint
        , body =
            jsonBody <|
                authParametersEncoder options
        , expect = Http.expectJson (RemoteData.fromResult >> msg) (credDecoder options.username)
        }


logout : Cmd msg
logout =
    storeCache Nothing


port storeCache : Maybe Value -> Cmd msg



-- SERIALIZATION
-- APPLICATION


application :
    Decoder a
    ->
        { init : Maybe a -> Url -> Nav.Key -> ( model, Cmd msg )
        , onUrlChange : Url -> msg
        , onUrlRequest : Browser.UrlRequest -> msg
        , subscriptions : model -> Sub msg
        , update : msg -> model -> ( model, Cmd msg )
        , view : model -> Browser.Document msg
        }
    -> Program Value model msg
application flagsDecoder config =
    let
        init flags url navKey =
            let
                flags_ =
                    Decode.decodeValue Decode.string flags
                        |> Result.andThen (Decode.decodeString flagsDecoder)
            in
            config.init (flags_ |> Result.toMaybe) url navKey
    in
    Browser.application
        { init = init
        , onUrlChange = config.onUrlChange
        , onUrlRequest = config.onUrlRequest
        , subscriptions = config.subscriptions
        , update = config.update
        , view = config.view
        }


storageDecoder : Decoder (Cred -> a) -> Decoder a
storageDecoder viewerDecoder =
    Decode.field "user" (decoderFromCred viewerDecoder)



-- HTTP


decoderFromCred : Decoder (Cred -> a) -> Decoder a
decoderFromCred decoder =
    Decode.map2 (\fromCred cred -> fromCred cred)
        decoder
        storedCredDecoder
