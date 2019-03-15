module Data.Section exposing (toCode, toIdentifier, toNavigationTitle, toSlug)

import Shared exposing (..)


toSlug : Section -> String
toSlug { identifier } =
    identifier.code
        ++ "/"
        ++ String.fromInt identifier.cycle
        ++ "/"
        ++ String.fromInt identifier.order


toNavigationTitle : Section -> String
toNavigationTitle { title } =
    title


toIdentifier : SectionIdentifier -> String
toIdentifier { code, cycle, order } =
    String.fromInt cycle ++ String.fromInt order


toCode : SectionIdentifier -> String
toCode { code } =
    code
