module Pages.Section exposing (view)

import Data.Slugable exposing (collectionView)
import Html exposing (..)
import Shared exposing (Group, Model, Msg, UriWithLabel)
import Views.Layout exposing (mainHeaderView, pageLayoutView, rowView)


view : Model -> Html.Html Msg
view model =
    pageLayoutView
        [ mainHeaderView "Activités / Groupes / Cibles / Sections"
        , rowView [ text "todo" ]
        ]
