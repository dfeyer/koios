module Page.Diary exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, article, div, footer, h1, h2, header, section, span, text)
import Html.Attributes exposing (class)
import Session exposing (Session)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Journal | Mon carnet de board IHES"
    , content =
        div []
            [ mainHeaderView (text "Journal")
            , section [ class "feed" ]
                [ feedItemView (text "Lundi, 1 mars 2019") [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis a eros molestie, malesuada lorem at, facilisis enim. Quisque at metus quis mi egestas aliquet ac non elit. Phasellus ut ante tincidunt, maximus massa ut, molestie orci. Suspendisse dui neque, porta id commodo vel, pharetra eget justo. Quisque finibus ipsum finibus ligula aliquet, nec lobortis urna vulputate. Integer nec sapien id ligula imperdiet efficitur eu vel dui. Aliquam posuere felis vel velit dignissim luctus. Pellentesque accumsan pellentesque vehicula. Donec condimentum varius nisi sit amet vehicula. Quisque est ex, rutrum ac tortor quis, finibus cursus sapien. Morbi mattis volutpat libero vel mollis. Donec bibendum bibendum massa, quis pretium nulla porttitor nec. " ]
                , feedItemView (text "Mardi, 2 mars 2019") [ text " Pellentesque vel finibus turpis, semper viverra diam. Sed eget pulvinar lectus, ut congue quam. In blandit erat in turpis pellentesque, nec congue risus molestie. Aliquam dapibus ut leo posuere mollis. Nunc in erat consectetur, consequat mi sit amet, congue ligula. Integer feugiat magna ut diam lacinia dapibus. Nam condimentum, lacus nec rutrum tristique, metus turpis dapibus enim, vitae malesuada tortor urna eget nisl. Proin vitae ultrices lacus, at ultrices turpis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sapien leo, maximus sed accumsan ac, sagittis quis est. Integer ac dapibus dui. Donec eget felis nisi. Nullam interdum euismod magna, ac sodales ante vehicula et. " ]
                , feedItemView (text "Mercredi, 3 mars 2019") [ text " Ut suscipit sit amet ex sit amet ultricies. Sed nisl sem, mattis vitae nunc eu, accumsan blandit augue. Nunc interdum arcu id consectetur pellentesque. Nullam lectus ex, sodales dignissim porta sit amet, pharetra ultrices ex. Proin non facilisis enim. Donec ornare commodo ante, et sagittis mauris euismod vel. Ut convallis sit amet lorem quis euismod. Aenean accumsan consequat diam, nec ultrices nunc fermentum a. Donec sagittis magna nec tincidunt condimentum. In tempor malesuada dignissim. Vestibulum ultricies eu ipsum eu suscipit. Suspendisse convallis nisi id mollis tincidunt. Curabitur venenatis, libero id ultricies blandit, metus arcu sodales ligula, sit amet laoreet nisl ligula eu leo. Aenean pharetra lacinia tortor, a sagittis tellus mattis vitae. " ]
                ]
            ]
    }


feedItemView : Html msg -> List (Html msg) -> Html msg
feedItemView label content =
    article [ class "feed-item" ]
        [ header [ class "feed-item__header" ]
            [ h2 [ class "feed-item__headline" ] [ label ] ]
        , div [ class "feed-item__content" ] content
        ]



-- UPDATE


type Msg
    = GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
