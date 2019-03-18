module Viewer exposing (Viewer)

import Username exposing (Username)



-- TYPES


type Viewer
    = Viewer Username



-- INFO


username : Viewer -> Username
username (Viewer u) =
    u


{-| Passwords must be at least this many characters long!
-}
minPasswordChars : Int
minPasswordChars =
    8
