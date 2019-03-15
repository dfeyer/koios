module Pages.Home exposing (view)

import Data.Group
import Data.Slugable exposing (collectionView)
import Html exposing (..)
import Shared exposing (Group, Model, Msg, UriWithLabel)
import Views.Layout exposing (mainHeaderView, pageLayoutView, rowView)


view : Model -> Html.Html Msg
view model =
    pageLayoutView
        [ mainHeaderView "Activités"
        , rowView [ collectionView model.activities Data.Group.toSlug Data.Group.toNavigationTitle ]
        ]
