module Pages.Home exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Shared exposing (Group, Model, Msg, UriWithLabel, toUriWithLabel)
import Views.Layout exposing (mainHeaderView, pageLayoutView, rowCenterView)


view : Model -> Html.Html Msg
view model =
    pageLayoutView
        [ mainHeaderView "Plan d'étude romand (PER)"
        , rowCenterView [ groupCollectionView model.activities ]
        ]


groupCollectionView : List Group -> Html Msg
groupCollectionView groups =
    groups
        |> groupListToUriWithLabel
        |> linkCollectionView


groupListToUriWithLabel : List Group -> List UriWithLabel
groupListToUriWithLabel groups =
    List.map groupToUriWithLabel groups


groupToUriWithLabel : Group -> UriWithLabel
groupToUriWithLabel { title, slug } =
    toUriWithLabel (activityPath (Just slug)) title slug


activityBasePath : String
activityBasePath =
    "activites/"


activityPath : Maybe String -> String
activityPath path =
    case path of
        Just p ->
            activityBasePath ++ p

        Nothing ->
            activityBasePath


linkCollectionView : List UriWithLabel -> Html Msg
linkCollectionView items =
    div [ class "collection" ] (List.map linkCollectionItemView items)


linkCollectionItemView : UriWithLabel -> Html Msg
linkCollectionItemView ( uri, label, slug ) =
    a [ href uri, class ("collection-item m-1 black-text fill-" ++ slug) ] [ text label ]
