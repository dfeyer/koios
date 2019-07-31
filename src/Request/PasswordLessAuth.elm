module Request.PasswordLessAuth exposing (AuthResponse, auth, authParameters)

import Http exposing (jsonBody)
import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import RemoteData exposing (RemoteData, WebData, sendRequest)



-- TYPE


type alias AuthResponse =
    { token : String
    }


type Endpoint
    = Endpoint String


type alias AuthParameters =
    { username : String
    , password : String
    }



-- TYPE HELPERS


authParameters : String -> String -> AuthParameters
authParameters username password =
    { username = username
    , password = password
    }


endpointToString : Endpoint -> String
endpointToString e =
    case e of
        Endpoint value ->
            value



-- ENDPOINTS


authEndpoint : Endpoint
authEndpoint =
    Endpoint "https://www-koios-backend.ttree.localhost/api/v1/auth/token"


auth : AuthParameters -> Cmd (WebData AuthResponse)
auth options =
    sendRequest <|
        Http.post
            (endpointToString <|
                authEndpoint
            )
            (jsonBody <|
                encodeAuthParameters options
            )
            decodeAuthResponse


encodeAuthParameters : AuthParameters -> Encode.Value
encodeAuthParameters p =
    Encode.object
        [ ( "username", Encode.string p.username )
        , ( "password", Encode.string p.password )
        ]


decodeAuthResponse : Decoder AuthResponse
decodeAuthResponse =
    Decode.succeed AuthResponse
        |> required "token" string
