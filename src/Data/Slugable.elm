module Data.Slugable exposing (Slug, Slugable, collectionView, compactCollectionView, filter)

import Data.UriWithLabel as UriWithLabel exposing (UriWithLabel)
import Html exposing (Html, a, li, ul)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)



-- TYPES


type alias Slugable a =
    { a | title : String, slug : Slug }


type alias Slug =
    String



-- VIEWS


collectionView : List (Slugable a) -> (Slugable a -> msg) -> (Slugable a -> Html msg) -> Html msg
collectionView list msg toTitle =
    list
        |> listToUriWithLabel msg toTitle
        |> linkCollectionView


compactCollectionView : List (Slugable a) -> (Slugable a -> msg) -> (Slugable a -> Html msg) -> Html msg
compactCollectionView list msg toTitle =
    list
        |> listToUriWithLabel msg toTitle
        |> linkCompactCollectionView


listToUriWithLabel : (Slugable a -> msg) -> (Slugable a -> Html msg) -> List (Slugable a) -> List (UriWithLabel msg)
listToUriWithLabel msg toTitle groups =
    List.map (toUriWithLabel msg toTitle) groups


toUriWithLabel : (Slugable a -> msg) -> (Slugable a -> Html msg) -> Slugable a -> UriWithLabel msg
toUriWithLabel msg toTitle d =
    UriWithLabel.toUriWithLabel (msg d) (toTitle d)


linkCollectionView : List (UriWithLabel msg) -> Html msg
linkCollectionView items =
    ul [ class "collection" ] (List.map linkCollectionItemView items)


linkCompactCollectionView : List (UriWithLabel msg) -> Html msg
linkCompactCollectionView items =
    ul [ class "collection collection--compact" ] (List.map linkCollectionItemView items)


linkCollectionItemView : UriWithLabel msg -> Html msg
linkCollectionItemView ( msg, label ) =
    li [ class "collection__item" ]
        [ a
            [ class "collection__link"
            , href "#"
            , onClick msg
            , class "collection-item black-text"
            ]
            [ label ]
        ]



-- FILTERS


filter : List (Slugable a) -> Slug -> Maybe (Slugable a)
filter list slug =
    List.filter (\g -> g.slug == slug) list
        |> List.head
