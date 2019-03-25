module Data.Target exposing (SlugableTarget, fromSlugableTarget, targetBySection, toHtml, toSlugableTarget, toString)

import Data.Group exposing (Group, Section, Target, Topic)
import Data.Section exposing (sectionByTopic)
import Data.Slugable exposing (Slug, Slugable)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)



-- TYPES


type alias SlugableTarget =
    Slugable
        { position : String
        }



-- INFO


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


toHtml : SlugableTarget -> Html msg
toHtml target =
    span [ class "label" ] [ text (toString (fromSlugableTarget target)) ]


toString : Target -> String
toString target =
    target.text


targetBySection : List Group -> Group -> Topic -> Section -> Maybe (List SlugableTarget)
targetBySection learnings group topic section =
    case sectionByTopic learnings group topic of
        Just sections ->
            case
                List.filter (\s -> s.id == section.id) sections
                    |> List.head
            of
                Just section_ ->
                    Just (List.map toSlugableTarget section_.targets)

                Nothing ->
                    Nothing

        Nothing ->
            Nothing
