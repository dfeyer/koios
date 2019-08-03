module Data.Activity exposing (Activity, ActivityId, fromString)


type ActivityId
    = ActivityId String


type alias Activity =
    { id : ActivityId
    , label : String
    }


fromString : String -> Activity
fromString label =
    { id = ActivityId label
    , label = label
    }
