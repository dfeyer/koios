module Page.FamilyProfile exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Components.ContentArea as ContentArea
import Html exposing (Html, button, div, h2, img, text)
import Html.Attributes exposing (class, src)
import RemoteData exposing (RemoteData, WebData)
import Request.Family exposing (FamiliyProfileRemoteData, Family, ParentProfile, Profile, loadFamilyProfile)
import Session exposing (Session)
import Shared exposing (filterNothing)
import Views.ActionList as ActionList
import Views.Button as Button
import Views.Layout exposing (mainHeaderWithChapterView)



-- MODEL


type alias Model =
    { session : Session
    , family : FamiliyProfileRemoteData
    }



-- TYPES
-- INIT


init : Session -> ( Model, Cmd Msg )
init session =
    ( initModel session
    , loadFamilyProfile session ProfileLoaded
    )


initModel : Session -> Model
initModel session =
    { session = session
    , family = RemoteData.NotAsked
    }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Connexion | Mon carnet de board IHES"
    , content =
        div []
            (case model.family of
                RemoteData.NotAsked ->
                    viewLoading

                RemoteData.Loading ->
                    viewLoading

                RemoteData.Failure _ ->
                    viewError

                RemoteData.Success family ->
                    viewProfile family
            )
    }


viewProfile : Family -> List (Html Msg)
viewProfile family =
    [ ContentArea.view
        [ mainHeaderWithChapterView
            (text "Profile")
            (text family.name)
        , ContentArea.infoBox
            [ ContentArea.secondaryTitle "Référants"
            , ActionList.viewWithActions
                (filterNothing family.parents)
                viewProfileLink
                [ viewAddProfileLink ]
            ]
        , ContentArea.infoBox
            [ ContentArea.secondaryTitle "Apprenants"
            , ActionList.viewWithActions
                (filterNothing family.childs)
                viewProfileLink
                [ viewAddProfileLink ]
            ]
        ]
    ]


viewProfileLink : Profile a -> Html Msg
viewProfileLink profile =
    ActionList.link
        [ img [ class "action-list__circular-image", src profile.avatarUrl ] []
        , div [] [ text profile.name ]
        ]


viewAddProfileLink : Html Msg
viewAddProfileLink =
    Button.view
        [ div [] [ text "Créer un nouveau compte" ]
        ]


viewLoading : List (Html Msg)
viewLoading =
    [ div [ class "login-form__wrapper-large" ] [ text "Chargement du profile en cours..." ]
    ]


viewError : List (Html Msg)
viewError =
    [ div [ class "login-form__wrapper-large" ] [ text "Oups, désolé impossible de traiter votre demande actuellement." ]
    ]



-- UPDATE


type Msg
    = GotSession Session
    | ProfileLoaded FamiliyProfileRemoteData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }
            , Cmd.none
            )

        ProfileLoaded response ->
            ( { model | family = response }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
