module Request.PasswordLessAuth.LinkType exposing (LinkType, sendAsCode, sendAsLink, toString)


type LinkType
    = Code
    | Link


sendAsCode : LinkType
sendAsCode =
    Code


sendAsLink : LinkType
sendAsLink =
    Link


toString : LinkType -> String
toString type_ =
    case type_ of
        Code ->
            "code"

        Link ->
            "link"
