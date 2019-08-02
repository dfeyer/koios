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
import Request.Graphql exposing (query)
import Session exposing (Session)



-- TYPES


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


type alias FamiliyProfileRemoteData =
    RemoteData (Graphql.Http.Error Family) Family



-- REQUEST


loadFamilyProfile : Session -> (FamiliyProfileRemoteData -> msg) -> Cmd msg
loadFamilyProfile session msg =
    query session familyProfileQuery msg



-- QUERY


familyProfileQuery : SelectionSet Family RootQuery
familyProfileQuery =
    Query.family familySelection


familySelection : SelectionSet Family GraphQL.Object.Family
familySelection =
    SelectionSet.map4 Family
        Family.id
        Family.name
        (Family.parents ParentProfile.name)
        (Family.childs ChildProfile.name)
