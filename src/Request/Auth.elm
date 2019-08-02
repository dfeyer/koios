module Request.Auth exposing (AuthParameters, AuthResponse, Endpoint, authEndpoint, authParameters, authParametersEncoder, endpoint, endpointToString)

import Json.Encode as Encode
import Username exposing (Username, createUsername)



-- TYPE


type alias AuthResponse =
    { token : String
    }


type Endpoint
    = Endpoint String


type alias AuthParameters =
    { username : Username
    , password : String
    }



-- TYPE HELPERS


authParameters : String -> String -> AuthParameters
authParameters username password =
    { username = createUsername username
    , password = password
    }


endpointToString : Endpoint -> String
endpointToString e =
    case e of
        Endpoint value ->
            value


endpoint : String -> Endpoint
endpoint s =
    Endpoint s



-- ENDPOINTS


authEndpoint : Endpoint
authEndpoint =
    Endpoint "https://www-koios-backend.ttree.localhost/api/v1/auth/token"


authParametersEncoder : AuthParameters -> Encode.Value
authParametersEncoder p =
    Encode.object
        [ ( "username", Username.encode p.username )
        , ( "password", Encode.string p.password )
        ]
