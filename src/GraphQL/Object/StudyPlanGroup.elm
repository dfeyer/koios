-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GraphQL.Object.StudyPlanGroup exposing (TopicRequiredArguments, code, id, name, next, plan, prev, slug, topic, topics)

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


id : SelectionSet GraphQL.ScalarCodecs.Id GraphQL.Object.StudyPlanGroup
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapCodecs |> .codecId |> .decoder)


code : SelectionSet String GraphQL.Object.StudyPlanGroup
code =
    Object.selectionForField "String" "code" [] Decode.string


slug : SelectionSet String GraphQL.Object.StudyPlanGroup
slug =
    Object.selectionForField "String" "slug" [] Decode.string


name : SelectionSet (Maybe String) GraphQL.Object.StudyPlanGroup
name =
    Object.selectionForField "(Maybe String)" "name" [] (Decode.string |> Decode.nullable)


topics : SelectionSet decodesTo GraphQL.Object.StudyPlanTopic -> SelectionSet (List (Maybe decodesTo)) GraphQL.Object.StudyPlanGroup
topics object_ =
    Object.selectionForCompositeField "topics" [] object_ (identity >> Decode.nullable >> Decode.list)


type alias TopicRequiredArguments =
    { id : GraphQL.ScalarCodecs.Id }


topic : TopicRequiredArguments -> SelectionSet decodesTo GraphQL.Object.StudyPlanTopic -> SelectionSet decodesTo GraphQL.Object.StudyPlanGroup
topic requiredArgs object_ =
    Object.selectionForCompositeField "topic" [ Argument.required "id" requiredArgs.id (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapEncoder .codecId) ] object_ identity


plan : SelectionSet decodesTo GraphQL.Object.StudyPlan -> SelectionSet decodesTo GraphQL.Object.StudyPlanGroup
plan object_ =
    Object.selectionForCompositeField "plan" [] object_ identity


next : SelectionSet decodesTo GraphQL.Object.StudyPlanGroup -> SelectionSet (Maybe decodesTo) GraphQL.Object.StudyPlanGroup
next object_ =
    Object.selectionForCompositeField "next" [] object_ (identity >> Decode.nullable)


prev : SelectionSet decodesTo GraphQL.Object.StudyPlanGroup -> SelectionSet (Maybe decodesTo) GraphQL.Object.StudyPlanGroup
prev object_ =
    Object.selectionForCompositeField "prev" [] object_ (identity >> Decode.nullable)
