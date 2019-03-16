module Tasks.Ui exposing (scrollToTop)

import Browser.Dom
import Task exposing (Task)


scrollToTop : Task x ()
scrollToTop =
    Browser.Dom.setViewport 0 0
        -- It's not worth showing the user anything special if scrolling fails.
        -- If anything, we'd log this to an error recording service.
        |> Task.onError (\_ -> Task.succeed ())
