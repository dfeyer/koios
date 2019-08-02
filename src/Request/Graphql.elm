module Request.Graphql exposing (query)

import Api exposing (token)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData)
import Session exposing (Session, viewer)
import Viewer exposing (cred)


endpoint : String
endpoint =
    "http://www-koios-backend.ttree.localhost/graphql"


query : Session -> SelectionSet a RootQuery -> (RemoteData (Graphql.Http.Error a) a -> msg) -> Cmd msg
query s q msg =
    case viewer s of
        Just v ->
            let
                bearer =
                    token <|
                        cred v
            in
            q
                |> Graphql.Http.queryRequest endpoint
                |> Graphql.Http.withHeader "Authorization" ("Bearer " ++ bearer)
                |> Graphql.Http.send (RemoteData.fromResult >> msg)

        Nothing ->
            q
                |> Graphql.Http.queryRequest endpoint
                |> Graphql.Http.send (RemoteData.fromResult >> msg)
