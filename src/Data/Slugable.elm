module Data.Slugable exposing (collectionView, compactCollectionView, filter)

import Html exposing (Html, a, div, li, text, ul)
import Html.Attributes exposing (class, href)
import Routes exposing (groupPath)
import Shared exposing (Group, Slug, Slugable, Topic, UriWithLabel)


collectionView : List (Slugable a) -> (Slugable a -> Slug) -> (Slugable a -> Html msg) -> Html msg
collectionView list slugify toTitle =
    list
        |> listToUriWithLabel slugify toTitle
        |> linkCollectionView


compactCollectionView : List (Slugable a) -> (Slugable a -> Slug) -> (Slugable a -> Html msg) -> Html msg
compactCollectionView list slugify toTitle =
    list
        |> listToUriWithLabel slugify toTitle
        |> linkCompactCollectionView


listToUriWithLabel : (Slugable a -> Slug) -> (Slugable a -> Html msg) -> List (Slugable a) -> List (UriWithLabel msg)
listToUriWithLabel slugify toTitle groups =
    List.map (toUriWithLabel slugify toTitle) groups


toUriWithLabel : (Slugable a -> Slug) -> (Slugable a -> Html msg) -> Slugable a -> UriWithLabel msg
toUriWithLabel slugify toTitle d =
    let
        slug_ =
            case d.slug of
                "#" ->
                    Nothing

                _ ->
                    Just (slugify d)
    in
    case slug_ of
        Just slug ->
            Shared.toUriWithLabel (groupPath slug) (toTitle d) slug

        Nothing ->
            Shared.labelWithoutUri (toTitle d)


linkCollectionView : List (UriWithLabel msg) -> Html msg
linkCollectionView items =
    ul [ class "collection" ] (List.map linkCollectionItemView items)


linkCompactCollectionView : List (UriWithLabel msg) -> Html msg
linkCompactCollectionView items =
    ul [ class "collection collection--compact" ] (List.map linkCollectionItemView items)


linkCollectionItemView : UriWithLabel msg -> Html msg
linkCollectionItemView ( uri, label, _ ) =
    case uri of
        Nothing ->
            li [ class "collection__item" ] [ div [ class "collection__link", class "collection-item black-text" ] [ label ] ]

        Just u ->
            li [ class "collection__item" ] [ a [ class "collection__link", href u, class "collection-item black-text" ] [ label ] ]


filter : List (Slugable a) -> Slug -> Maybe (Slugable a)
filter list slug =
    List.filter (\g -> g.slug == slug) list
        |> List.head
