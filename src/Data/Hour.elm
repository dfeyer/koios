module Data.Hour exposing (toString)


toString : Int -> Int -> String
toString hours minutes =
    let
        pad =
            \n ->
                String.padLeft 2 '0' (String.fromInt n)
    in
    pad hours ++ ":" ++ pad minutes
