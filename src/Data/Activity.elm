module Data.Activity exposing (Activity, ActivityId, createActivity)


type ActivityId
    = ActivityId String


type alias Activity =
    { id : ActivityId
    , label : String
    }


createActivity : String -> Activity
createActivity label =
    { id = ActivityId label
    , label = label
    }
