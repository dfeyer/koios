module Views.Calendar exposing (hourInterval, interval)

import Data.CustomProperty as CustomProperty
import Html exposing (..)


interval : Int -> Int -> Attribute msg
interval start end =
    CustomProperty.fromList
        [ ( "start", String.fromInt start )
        , ( "end", String.fromInt end )
        ]


hourInterval : Int -> Attribute msg
hourInterval start =
    interval start (start + 1)
