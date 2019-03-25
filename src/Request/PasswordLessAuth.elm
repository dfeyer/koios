module Request.PasswordLessAuth exposing (Start, StartResponse, VerifyResponse, start, startByEmail, verify, verifyByEmail)

import Http exposing (jsonBody)
import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import RemoteData exposing (RemoteData, WebData, sendRequest)
import Request.PasswordLessAuth.Connection as Connection exposing (Connection, connectWithEmail)
import Request.PasswordLessAuth.GrantType as GrantType exposing (GrantType)
import Request.PasswordLessAuth.LinkType as LinkType exposing (LinkType)


type Endpoint
    = Endpoint String


startEndpoint : Endpoint
startEndpoint =
    Endpoint "https://koios.eu.auth0.com/passwordless/start"


verifyEndpoint : Endpoint
verifyEndpoint =
    Endpoint "https://koios.eu.auth0.com/oauth/token"


endpointToString : Endpoint -> String
endpointToString e =
    case e of
        Endpoint value ->
            value


type ClientId
    = ClientId String


clientId : ClientId
clientId =
    ClientId "m46vXrYcNOUWJIOegGaHXsxomn6c87PN"


clientIdToString : ClientId -> String
clientIdToString c =
    case c of
        ClientId value ->
            value


startByEmail : String -> Start
startByEmail email =
    { clientId = clientId
    , connection = Connection.connectWithEmail
    , email = email
    , send = LinkType.sendAsCode
    }


type alias Start =
    { clientId : ClientId
    , connection : Connection
    , email : String
    , send : LinkType
    }


encodeStart : Start -> Encode.Value
encodeStart p =
    Encode.object
        [ ( "client_id", clientIdToString p.clientId |> Encode.string )
        , ( "connection", Connection.toString p.connection |> Encode.string )
        , ( "email", Encode.string p.email )
        , ( "send", LinkType.toString p.send |> Encode.string )
        ]


type alias StartResponse =
    { id : String
    , email : String
    , emailVerified : Bool
    }


decodeStartResponse : Decoder StartResponse
decodeStartResponse =
    Decode.succeed StartResponse
        |> required "_id" string
        |> required "email" string
        |> required "email_verified" bool


start : Start -> Cmd (WebData StartResponse)
start options =
    sendRequest <|
        Http.post
            (endpointToString <|
                startEndpoint
            )
            (jsonBody <|
                encodeStart options
            )
            decodeStartResponse


type alias Verify =
    { clientId : ClientId
    , connection : Connection
    , username : String
    , password : String
    }


verifyByEmail : String -> String -> Verify
verifyByEmail email code =
    { clientId = clientId
    , connection = Connection.connectWithEmail
    , username = email
    , password = code
    }


encodeVerify : Verify -> Encode.Value
encodeVerify v =
    Encode.object
        [ ( "client_id", clientIdToString v.clientId |> Encode.string )
        , ( "connection", Connection.toString v.connection |> Encode.string )
        , ( "grant_type", Encode.string "password" )
        , ( "username", Encode.string v.username )
        , ( "password", Encode.string v.password )
        , ( "scope", Encode.string "offline_access" )
        ]


type alias VerifyResponse =
    { accessToken : String
    , refreshToken : String
    , idToken : String
    , tokentType : String
    , expiresIn : Int
    }


decodeVerifyResponse : Decoder VerifyResponse
decodeVerifyResponse =
    Decode.succeed VerifyResponse
        |> required "access_token" string
        |> required "refresh_token" string
        |> required "id_token" string
        |> required "token_type" string
        |> required "expires_in" int


verify : Verify -> Cmd (WebData VerifyResponse)
verify options =
    sendRequest <|
        Http.post
            (endpointToString <|
                verifyEndpoint
            )
            (jsonBody <|
                encodeVerify options
            )
            decodeVerifyResponse
