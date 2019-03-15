module Data.Group exposing (toSlug, toNavigationTitle)

import Shared exposing (..)


toSlug : Group -> String
toSlug group =
    group.slug

toNavigationTitle : Group -> String
toNavigationTitle group =
    group.title
