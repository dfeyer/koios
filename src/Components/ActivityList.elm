module Components.ActivityList exposing (view)

import Components.ContentArea as ContentArea
import Data.Activity exposing (Activity)
import Html exposing (Html, text)
import Views.ActionList as ActionList


view : List Activity -> Html msg
view list =
    ContentArea.infoBox
        [ ContentArea.secondaryTitle "Propositions d'activités"
        , ActionList.view list preview
        ]


preview : Activity -> Html msg
preview { label } =
    ActionList.link [ text label ]
