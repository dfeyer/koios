module Request.Family exposing (Family, familySelection, query)

import GraphQL.Object
import GraphQL.Object.ChildProfile as ChildProfile
import GraphQL.Object.Family as Family
import GraphQL.Object.ParentProfile as ParentProfile
import GraphQL.Query as Query
import GraphQL.Scalar
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)


query : SelectionSet (Maybe Family) RootQuery
query =
    Query.family familySelection


type alias Family =
    { id : GraphQL.Scalar.Id
    , name : Maybe String
    , parents : List (Maybe String)
    , childs : List (Maybe String)
    }


type alias Parent =
    { id : GraphQL.Scalar.Id
    , name : Maybe String
    }


familySelection : SelectionSet Family GraphQL.Object.Family
familySelection =
    SelectionSet.map4 Family
        Family.id
        Family.name
        (Family.parents ParentProfile.name)
        (Family.childs ChildProfile.name)
