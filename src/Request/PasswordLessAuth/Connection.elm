module Request.PasswordLessAuth.Connection exposing (Connection, connectWithEmail, connectWithSms, fromString, toString)


type Connection
    = Email
    | Sms


connectWithEmail : Connection
connectWithEmail =
    Email


connectWithSms : Connection
connectWithSms =
    Sms


toString : Connection -> String
toString conn =
    case conn of
        Email ->
            "email"

        Sms ->
            "Sms"


fromString : String -> Maybe Connection
fromString value =
    case value of
        "email" ->
            Just connectWithEmail

        "Sms" ->
            Just connectWithSms

        _ ->
            Nothing
