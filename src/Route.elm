module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing (..)


type Route
    = Learning
    | Schedule
    | Diary
    | Calendar
    | Login


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Learning top
        , map Schedule (s "semainier")
        , map Diary (s "journal")
        , map Calendar (s "calendrier")
        , map Login (s "connexion")
        ]



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    url
        |> Parser.parse parser



-- INTERNAL


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Learning ->
                    []

                Schedule ->
                    [ "semainier" ]

                Diary ->
                    [ "journal" ]

                Calendar ->
                    [ "calendrier" ]

                Login ->
                    [ "connexion" ]
    in
    "/" ++ String.join "/" pieces
