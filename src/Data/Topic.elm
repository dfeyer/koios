module Data.Topic exposing (toSlug, toNavigationTitle)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href)
import Routes exposing (activityGroupPath)
import Shared exposing (Group, Slugable, Topic, UriWithLabel)


toSlug : Group -> Topic -> String
toSlug group topic =
    group.slug ++ "/" ++ topic.slug

toNavigationTitle : Topic -> String
toNavigationTitle topic =
    topic.title
