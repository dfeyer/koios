-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GraphQL.Object.StudyPlanTopic exposing (group, id, name, sections)

import GraphQL.InputObject
import GraphQL.Interface
import GraphQL.Object
import GraphQL.Scalar
import GraphQL.ScalarCodecs
import GraphQL.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


id : SelectionSet GraphQL.ScalarCodecs.Id GraphQL.Object.StudyPlanTopic
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapCodecs |> .codecId |> .decoder)


name : SelectionSet (Maybe String) GraphQL.Object.StudyPlanTopic
name =
    Object.selectionForField "(Maybe String)" "name" [] (Decode.string |> Decode.nullable)


sections : SelectionSet decodesTo GraphQL.Object.StudyPlanSection -> SelectionSet (List (Maybe decodesTo)) GraphQL.Object.StudyPlanTopic
sections object_ =
    Object.selectionForCompositeField "sections" [] object_ (identity >> Decode.nullable >> Decode.list)


group : SelectionSet decodesTo GraphQL.Object.StudyPlanGroup -> SelectionSet decodesTo GraphQL.Object.StudyPlanTopic
group object_ =
    Object.selectionForCompositeField "group" [] object_ identity
