-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GraphQL.Object.StudyPlanSection exposing (TargetRequiredArguments, code, id, name, next, prev, slug, target, targets, topic)

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


id : SelectionSet GraphQL.ScalarCodecs.Id GraphQL.Object.StudyPlanSection
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapCodecs |> .codecId |> .decoder)


code : SelectionSet String GraphQL.Object.StudyPlanSection
code =
    Object.selectionForField "String" "code" [] Decode.string


slug : SelectionSet String GraphQL.Object.StudyPlanSection
slug =
    Object.selectionForField "String" "slug" [] Decode.string


name : SelectionSet (Maybe String) GraphQL.Object.StudyPlanSection
name =
    Object.selectionForField "(Maybe String)" "name" [] (Decode.string |> Decode.nullable)


targets : SelectionSet decodesTo GraphQL.Object.StudyPlanTarget -> SelectionSet (List (Maybe decodesTo)) GraphQL.Object.StudyPlanSection
targets object_ =
    Object.selectionForCompositeField "targets" [] object_ (identity >> Decode.nullable >> Decode.list)


type alias TargetRequiredArguments =
    { id : GraphQL.ScalarCodecs.Id }


target : TargetRequiredArguments -> SelectionSet decodesTo GraphQL.Object.StudyPlanTarget -> SelectionSet decodesTo GraphQL.Object.StudyPlanSection
target requiredArgs object_ =
    Object.selectionForCompositeField "target" [ Argument.required "id" requiredArgs.id (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapEncoder .codecId) ] object_ identity


topic : SelectionSet decodesTo GraphQL.Object.StudyPlanTopic -> SelectionSet decodesTo GraphQL.Object.StudyPlanSection
topic object_ =
    Object.selectionForCompositeField "topic" [] object_ identity


next : SelectionSet decodesTo GraphQL.Object.StudyPlanGroup -> SelectionSet (Maybe decodesTo) GraphQL.Object.StudyPlanSection
next object_ =
    Object.selectionForCompositeField "next" [] object_ (identity >> Decode.nullable)


prev : SelectionSet decodesTo GraphQL.Object.StudyPlanGroup -> SelectionSet (Maybe decodesTo) GraphQL.Object.StudyPlanSection
prev object_ =
    Object.selectionForCompositeField "prev" [] object_ (identity >> Decode.nullable)
