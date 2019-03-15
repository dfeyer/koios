module Data.Section exposing (toSlug, toNavigationTitle)

import Shared exposing (..)

toSlug : Group -> Topic -> Section -> String
toSlug group topic { identifier } =
    identifier.code

toNavigationTitle : Section -> String
toNavigationTitle section =
    section.title

