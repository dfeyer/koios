module Data.CustomProperty exposing (fromList)

import Html exposing (Attribute)
import Html.Attributes


fromList : List ( String, String ) -> Attribute msg
fromList list =
    Html.Attributes.attribute "style" <|
        (List.map (\( name, value ) -> prefixName name ++ ": " ++ value) list
            |> List.intersperse "; "
            |> String.concat
        )


prefixName : String -> String
prefixName string =
    "--" ++ string
