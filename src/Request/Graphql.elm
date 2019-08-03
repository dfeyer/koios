module Request.Graphql exposing (query)

import Api exposing (token)
import Graphql.Http exposing (Request)
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData)
import Session exposing (Session, viewer)
import Viewer exposing (Viewer, cred)


endpoint : String
endpoint =
    "http://www-koios-backend.ttree.localhost/graphql"


query : Session -> SelectionSet a RootQuery -> (RemoteData (Graphql.Http.Error a) a -> msg) -> Cmd msg
query s q msg =
    Graphql.Http.send (RemoteData.fromResult >> msg) <|
        (q
            |> Graphql.Http.queryRequest endpoint
            |> Graphql.Http.withHeader "X-Koios-Powered" "Koios/dev"
            |> (case viewer s of
                    Just v ->
                        withBearer v

                    Nothing ->
                        identity
               )
        )


withBearer : Viewer -> Request decodesTo -> Request decodesTo
withBearer v =
    Graphql.Http.withHeader "Authorization"
        ("Bearer "
            ++ (token <|
                    cred v
               )
        )
