module Data.UriWithLabel exposing (UriWithLabel, toUriWithLabel)

import Html exposing (Html)



-- TYPES


type alias UriWithLabel msg =
    ( msg, Html msg )



-- CONSTRUCTORS


toUriWithLabel : msg -> Html msg -> UriWithLabel msg
toUriWithLabel msg label =
    ( msg, label )
