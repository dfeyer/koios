module Data.UriWithLabel exposing (UriWithLabel, toUriWithLabel)

import Html exposing (Html)



-- TYPES


type alias UriWithLabel msg =
    ( msg, Html msg, String )



-- CONSTRUCTORS


toUriWithLabel : msg -> Html msg -> String -> UriWithLabel msg
toUriWithLabel msg label slug =
    ( msg, label, slug )
