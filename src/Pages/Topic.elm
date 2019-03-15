module Pages.Topic exposing (view)

import Data.Section
import Data.Slugable exposing (compactCollectionView)
import Html exposing (..)
import Shared exposing (Group, Model, Msg, Slug, Slugable, Topic, UriWithLabel)
import Views.Layout exposing (mainHeaderWithChapterView, pageLayoutView, rowView)


view : Model -> Group -> Topic -> Html.Html Msg
view model group topic =
    pageLayoutView
        [ mainHeaderWithChapterView group.title topic.title
        , rowView [ compactCollectionView topic.sections (Data.Section.toSlug group topic) Data.Section.toNavigationTitle ]
        ]
