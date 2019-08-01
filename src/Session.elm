module Session exposing (Session, changes, fromViewer, isLoggedIn, navKey, viewer)

import Api
import Browser.Navigation as Nav
import Viewer exposing (Viewer)



-- TYPES


type Session
    = LoggedIn Nav.Key Viewer
    | Guest Nav.Key


isLoggedIn : Session -> Bool
isLoggedIn session =
    case session of
        LoggedIn _ _ ->
            True

        Guest _ ->
            False



-- INFO


viewer : Session -> Maybe Viewer
viewer session =
    case session of
        LoggedIn _ v ->
            Just v

        Guest _ ->
            Nothing


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key



-- CHANGES


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Api.viewerChanges (\maybeViewer -> toMsg (fromViewer key maybeViewer)) Viewer.decoder


fromViewer : Nav.Key -> Maybe Viewer -> Session
fromViewer key maybeViewer =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    case maybeViewer of
        Just viewerVal ->
            LoggedIn key viewerVal

        Nothing ->
            Guest key
