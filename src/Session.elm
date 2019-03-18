module Session exposing (Session, changes, fromViewer, learningList, navKey, viewer)

import Browser.Navigation as Nav
import Shared exposing (Group)
import Viewer exposing (Viewer)



-- TYPES


type Session
    = LoggedIn Nav.Key Viewer (List Group)
    | Guest Nav.Key (List Group)



-- INFO


viewer : Session -> Maybe Viewer
viewer session =
    case session of
        LoggedIn _ v _ ->
            Just v

        Guest _ _ ->
            Nothing


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ _ ->
            key

        Guest key _ ->
            key


learningList : Session -> List Group
learningList session =
    case session of
        LoggedIn _ _ learnings ->
            learnings

        Guest _ learnings ->
            learnings



-- CHANGES


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Sub.none


fromViewer : Nav.Key -> Maybe Viewer -> List Group -> Session
fromViewer key maybeViewer learnings =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    case maybeViewer of
        Just viewerVal ->
            LoggedIn key viewerVal learnings

        Nothing ->
            Guest key learnings
