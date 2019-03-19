module Data.Section exposing (toCode, toHtml, toIdentifier, toSlug, toString)

import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Shared exposing (..)


toSlug : Section -> String
toSlug { identifier } =
    identifier.code
        ++ "/"
        ++ String.fromInt identifier.cycle
        ++ "/"
        ++ String.fromInt identifier.order


toHtml : Section -> Html msg
toHtml section =
    span [ class "label" ] [ text (toString section) ]


toString : Section -> String
toString { title } =
    title


toIdentifier : SectionIdentifier -> String
toIdentifier { code, cycle, order } =
    String.fromInt cycle ++ String.fromInt order


toCode : SectionIdentifier -> String
toCode { code } =
    code
