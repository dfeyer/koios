-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GraphQL.Object.ChildProfile exposing (AvatarUrlOptionalArguments, accessLevel, address, avatarUrl, country, creationDate, email, facebook, family, fax, firstname, id, instagram, lastname, locality, mastodon, mobile, name, phone, postalCode, profilePublic, profileValidated, slug, twitter, username, website)

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


id : SelectionSet GraphQL.ScalarCodecs.Id GraphQL.Object.ChildProfile
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapCodecs |> .codecId |> .decoder)


slug : SelectionSet String GraphQL.Object.ChildProfile
slug =
    Object.selectionForField "String" "slug" [] Decode.string


creationDate : SelectionSet GraphQL.ScalarCodecs.DateTime GraphQL.Object.ChildProfile
creationDate =
    Object.selectionForField "ScalarCodecs.DateTime" "creationDate" [] (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


accessLevel : SelectionSet Int GraphQL.Object.ChildProfile
accessLevel =
    Object.selectionForField "Int" "accessLevel" [] Decode.int


profilePublic : SelectionSet Bool GraphQL.Object.ChildProfile
profilePublic =
    Object.selectionForField "Bool" "profilePublic" [] Decode.bool


profileValidated : SelectionSet Bool GraphQL.Object.ChildProfile
profileValidated =
    Object.selectionForField "Bool" "profileValidated" [] Decode.bool


type alias AvatarUrlOptionalArguments =
    { size : OptionalArgument Int }


avatarUrl : (AvatarUrlOptionalArguments -> AvatarUrlOptionalArguments) -> SelectionSet String GraphQL.Object.ChildProfile
avatarUrl fillInOptionals =
    let
        filledInOptionals =
            fillInOptionals { size = Absent }

        optionalArgs =
            [ Argument.optional "size" filledInOptionals.size Encode.int ]
                |> List.filterMap identity
    in
    Object.selectionForField "String" "avatarUrl" optionalArgs Decode.string


username : SelectionSet String GraphQL.Object.ChildProfile
username =
    Object.selectionForField "String" "username" [] Decode.string


name : SelectionSet String GraphQL.Object.ChildProfile
name =
    Object.selectionForField "String" "name" [] Decode.string


firstname : SelectionSet String GraphQL.Object.ChildProfile
firstname =
    Object.selectionForField "String" "firstname" [] Decode.string


lastname : SelectionSet String GraphQL.Object.ChildProfile
lastname =
    Object.selectionForField "String" "lastname" [] Decode.string


address : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
address =
    Object.selectionForField "(Maybe String)" "address" [] (Decode.string |> Decode.nullable)


postalCode : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
postalCode =
    Object.selectionForField "(Maybe String)" "postalCode" [] (Decode.string |> Decode.nullable)


locality : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
locality =
    Object.selectionForField "(Maybe String)" "locality" [] (Decode.string |> Decode.nullable)


country : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
country =
    Object.selectionForField "(Maybe String)" "country" [] (Decode.string |> Decode.nullable)


phone : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
phone =
    Object.selectionForField "(Maybe String)" "phone" [] (Decode.string |> Decode.nullable)


mobile : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
mobile =
    Object.selectionForField "(Maybe String)" "mobile" [] (Decode.string |> Decode.nullable)


fax : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
fax =
    Object.selectionForField "(Maybe String)" "fax" [] (Decode.string |> Decode.nullable)


email : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
email =
    Object.selectionForField "(Maybe String)" "email" [] (Decode.string |> Decode.nullable)


website : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
website =
    Object.selectionForField "(Maybe String)" "website" [] (Decode.string |> Decode.nullable)


twitter : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
twitter =
    Object.selectionForField "(Maybe String)" "twitter" [] (Decode.string |> Decode.nullable)


facebook : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
facebook =
    Object.selectionForField "(Maybe String)" "facebook" [] (Decode.string |> Decode.nullable)


instagram : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
instagram =
    Object.selectionForField "(Maybe String)" "instagram" [] (Decode.string |> Decode.nullable)


mastodon : SelectionSet (Maybe String) GraphQL.Object.ChildProfile
mastodon =
    Object.selectionForField "(Maybe String)" "mastodon" [] (Decode.string |> Decode.nullable)


family : SelectionSet decodesTo GraphQL.Object.Family -> SelectionSet decodesTo GraphQL.Object.ChildProfile
family object_ =
    Object.selectionForCompositeField "family" [] object_ identity
