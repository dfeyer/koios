module Request.Family exposing (FamiliyProfileRemoteData, Family, Profile, familySelection, loadFamilyProfile)

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
    , name : String
    , parents : List (Maybe ParentProfile)
    , childs : List (Maybe ChildProfile)
    }


type alias Profile a =
    { a | id : GraphQL.Scalar.Id, name : String, avatarUrl : String }


type alias ParentProfile =
    Profile {}


parentProfile : GraphQL.Scalar.Id -> String -> String -> ParentProfile
parentProfile id name avatarUrl =
    { id = id
    , name = name
    , avatarUrl = avatarUrl
    }


type alias ChildProfile =
    Profile {}


childProfile : GraphQL.Scalar.Id -> String -> String -> ChildProfile
childProfile id name avatarUrl =
    { id = id
    , name = name
    , avatarUrl = avatarUrl
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
        (Family.parents parentProfileSelection)
        (Family.childs childProfileSelection)


parentProfileSelection : SelectionSet ParentProfile GraphQL.Object.ParentProfile
parentProfileSelection =
    SelectionSet.map3 parentProfile
        ParentProfile.id
        ParentProfile.name
        (ParentProfile.avatarUrl identity)


childProfileSelection : SelectionSet ChildProfile GraphQL.Object.ChildProfile
childProfileSelection =
    SelectionSet.map3 childProfile
        ChildProfile.id
        ChildProfile.name
        (ChildProfile.avatarUrl identity)
