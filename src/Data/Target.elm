module Data.Target exposing (toSlug, toSlugableList)

import Shared exposing (Group, SectionIdentifier, Slug, Slugable, SlugableTarget, Target, Topic, UriWithLabel, toSlugableTarget)


toSlugableList : List Target -> List SlugableTarget
toSlugableList targets =
    List.map toSlugableTarget targets


toSlug : SlugableTarget -> Slug
toSlug _ =
    "#"
