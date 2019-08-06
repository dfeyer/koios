module Shared exposing (UUID, filterNothing)


type alias UUID =
    String


filterNothing : List (Maybe a) -> List a
filterNothing list =
    List.filterMap (\x -> x) list
