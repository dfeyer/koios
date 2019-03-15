module Pages.Home exposing (view)

import Data.Group
import Data.Slugable exposing (collectionView)
import Html exposing (..)
import Html.Attributes exposing (class)
import Shared exposing (Group, Model, Msg, UriWithLabel)
import Views.Layout exposing (mainHeaderView, pageLayoutView, rowView)


view : Model -> Html.Html Msg
view model =
    pageLayoutView
        [ mainHeaderView (text "Activités")
        , rowView [ collectionView model.activities Data.Group.toSlug title ]
        ]


title : Group -> Html msg
title group =
    span [ class "label" ] [ text (Data.Group.toNavigationTitle group) ]
