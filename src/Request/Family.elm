module Request.Family exposing (Family, familySelection, query)

import GraphQL.Object
import GraphQL.Object.Family as Family
import GraphQL.Query as Query
import GraphQL.Scalar
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import RemoteData


query : SelectionSet (Maybe Family) RootQuery
query =
    Query.family familySelection


type alias Family =
    { id : GraphQL.Scalar.Id
    , name : Maybe String
    }


familySelection : SelectionSet Family GraphQL.Object.Family
familySelection =
    SelectionSet.map2 Family
        Family.id
        Family.name
