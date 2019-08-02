module Request.Family exposing (FamiliyProfileRemoteData, Family, familySelection, loadFamilyProfile)

import GraphQL.Object
import GraphQL.Object.ChildProfile as ChildProfile
import GraphQL.Object.Family as Family
import GraphQL.Object.ParentProfile as ParentProfile
import GraphQL.Query as Query
import GraphQL.Scalar
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData)



-- TYPES


type alias FamiliyProfileResponse =
    Maybe Family


type alias FamiliyProfileRemoteData =
    RemoteData (Graphql.Http.Error FamiliyProfileResponse) FamiliyProfileResponse



-- REQUEST


loadFamilyProfile : (FamiliyProfileRemoteData -> msg) -> Cmd msg
loadFamilyProfile msg =
    familyProfileQuery
        |> Graphql.Http.queryRequest "http://www-koios-backend.ttree.localhost/graphql"
        -- todo add the bearer and test backend auth
        |> Graphql.Http.send (RemoteData.fromResult >> msg)



-- QUERY


familyProfileQuery : SelectionSet (Maybe Family) RootQuery
familyProfileQuery =
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
