module Request.PasswordLessAuth.GrantType exposing (GrantType, fromString, toString, withPassword)


type GrantType
    = Password


withPassword : GrantType
withPassword =
    Password


toString : GrantType -> String
toString grantType =
    case grantType of
        Password ->
            "password"


fromString : String -> Maybe GrantType
fromString value =
    case value of
        "password" ->
            Just Password

        _ ->
            Nothing
