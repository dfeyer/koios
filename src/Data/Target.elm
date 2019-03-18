module Data.Target exposing (fromSlugableTarget, toNavigationTitle, toSlug, toSlugableList, toSlugableTarget)

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


toNavigationTitle : Target -> String
toNavigationTitle target =
    target.text
