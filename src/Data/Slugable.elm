module Data.Slugable exposing (collectionView, compactCollectionView, filter)

import Html exposing (Html, a, div, li, text, ul)
import Html.Attributes exposing (class, href)
import Routes exposing (activityGroupPath)
import Shared exposing (Group, Slug, Slugable, Topic, UriWithLabel)


collectionView : List (Slugable a) -> (Slugable a -> Slug) -> (Slugable a -> String) -> Html msg
collectionView list slugify toTitle =
    list
        |> listToUriWithLabel slugify toTitle
        |> linkCollectionView


compactCollectionView : List (Slugable a) -> (Slugable a -> Slug) -> (Slugable a -> String) -> Html msg
compactCollectionView list slugify toTitle =
    list
        |> listToUriWithLabel slugify toTitle
        |> linkCompactCollectionView


listToUriWithLabel : (Slugable a -> Slug) -> (Slugable a -> String) -> List (Slugable a) -> List UriWithLabel
listToUriWithLabel slugify toTitle groups =
    List.map (toUriWithLabel slugify toTitle) groups


toUriWithLabel : (Slugable a -> Slug) -> (Slugable a -> String) -> Slugable a -> UriWithLabel
toUriWithLabel slugify toTitle ({ title, slug } as d) =
    let
        s =
            slugify d
    in
    ( activityGroupPath s, toTitle d, s )


linkCollectionView : List UriWithLabel -> Html msg
linkCollectionView items =
    ul [ class "collection" ] (List.map linkCollectionItemView items)


linkCompactCollectionView : List UriWithLabel -> Html msg
linkCompactCollectionView items =
    ul [ class "collection collection--compact" ] (List.map linkCollectionItemView items)


linkCollectionItemView : UriWithLabel -> Html msg
linkCollectionItemView ( uri, label, _ ) =
    li [ class "collection__item" ] [ a [ class "collection__link", href uri, class "collection-item black-text" ] [ text label ] ]


filter : List (Slugable a) -> Slug -> Maybe (Slugable a)
filter list slug =
    List.filter (\g -> g.slug == slug) list
        |> List.head
