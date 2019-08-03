module Page.FamilyProfile exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Components.ContentArea as ContentArea
import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (class)
import RemoteData exposing (RemoteData, WebData)
import Request.Family exposing (FamiliyProfileRemoteData, Family, Profile, loadFamilyProfile)
import Session exposing (Session)
import Views.ActionList as ActionList
import Views.Layout exposing (mainHeaderView)



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
        [ ContentArea.infoBox
            [ ContentArea.primaryTitle family.name
            , ContentArea.introduction "Ut suscipit sit amet ex sit amet ultricies. Sed nisl sem, mattis vitae nunc eu, accumsan blandit augue. Nunc interdum arcu id consectetur pellentesque. Nullam lectus ex, sodales dignissim porta sit amet, pharetra ultrices ex. Proin non facilisis enim. Donec ornare commodo ante, et sagittis mauris euismod vel. Ut convallis sit amet lorem quis euismod. Aenean accumsan consequat diam, nec ultrices nunc fermentum a. Donec sagittis magna nec tincidunt condimentum. In tempor malesuada dignissim. Vestibulum ultricies eu ipsum eu suscipit. Suspendisse convallis nisi id mollis tincidunt."
            ]
        , ContentArea.infoBox
            [ ContentArea.secondaryTitle "Référants"
            , ActionList.view family.parents viewProfileLink
            ]
        , ContentArea.infoBox
            [ ContentArea.secondaryTitle "Apprenants"
            , ActionList.view family.childs viewProfileLink
            ]
        ]
    ]


viewProfileLink : Maybe (Profile a) -> Html Msg
viewProfileLink maybeProfile =
    case maybeProfile of
        Just profile ->
            ActionList.link [ div [] [ text profile.name ] ]

        Nothing ->
            ActionList.link [ div [] [] ]


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
    = NoOp
    | GotSession Session
    | ProfileLoaded FamiliyProfileRemoteData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        GotSession _ ->
            ( model
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
