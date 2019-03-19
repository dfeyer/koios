module Data.Target exposing (fromSlugableTarget, toHtml, toSlug, toSlugableList, toSlugableTarget, toString)

import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Shared exposing (Group, SectionIdentifier, Slug, Slugable, SlugableTarget, Target, Topic, UriWithLabel)


toSlugableList : List Target -> List SlugableTarget
toSlugableList targets =
    List.map toSlugableTarget targets


toSlugableTarget : Target -> SlugableTarget
toSlugableTarget { text, position } =
    { title = text
    , slug = "#"
    , position = position
    }


fromSlugableTarget : SlugableTarget -> Target
fromSlugableTarget slugable =
    { text = slugable.title
    , position = slugable.position
    }


toSlug : SlugableTarget -> Slug
toSlug _ =
    "#"


toHtml : SlugableTarget -> Html msg
toHtml target =
    span [ class "label" ] [ text (toString (fromSlugableTarget target)) ]


toString : Target -> String
toString target =
    target.text
