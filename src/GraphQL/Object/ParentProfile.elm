-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GraphQL.Object.ParentProfile exposing (AvatarUrlOptionalArguments, accessLevel, address, avatarUrl, country, creationDate, email, facebook, family, fax, firstname, id, instagram, lastname, locality, mastodon, mobile, name, phone, postalCode, profilePublic, profileValidated, twitter, username, website)

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


id : SelectionSet GraphQL.ScalarCodecs.Id GraphQL.Object.ParentProfile
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapCodecs |> .codecId |> .decoder)


creationDate : SelectionSet GraphQL.ScalarCodecs.DateTime GraphQL.Object.ParentProfile
creationDate =
    Object.selectionForField "ScalarCodecs.DateTime" "creationDate" [] (GraphQL.ScalarCodecs.codecs |> GraphQL.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


accessLevel : SelectionSet Int GraphQL.Object.ParentProfile
accessLevel =
    Object.selectionForField "Int" "accessLevel" [] Decode.int


profilePublic : SelectionSet Bool GraphQL.Object.ParentProfile
profilePublic =
    Object.selectionForField "Bool" "profilePublic" [] Decode.bool


profileValidated : SelectionSet Bool GraphQL.Object.ParentProfile
profileValidated =
    Object.selectionForField "Bool" "profileValidated" [] Decode.bool


type alias AvatarUrlOptionalArguments =
    { size : OptionalArgument Int }


avatarUrl : (AvatarUrlOptionalArguments -> AvatarUrlOptionalArguments) -> SelectionSet String GraphQL.Object.ParentProfile
avatarUrl fillInOptionals =
    let
        filledInOptionals =
            fillInOptionals { size = Absent }

        optionalArgs =
            [ Argument.optional "size" filledInOptionals.size Encode.int ]
                |> List.filterMap identity
    in
    Object.selectionForField "String" "avatarUrl" optionalArgs Decode.string


username : SelectionSet String GraphQL.Object.ParentProfile
username =
    Object.selectionForField "String" "username" [] Decode.string


name : SelectionSet String GraphQL.Object.ParentProfile
name =
    Object.selectionForField "String" "name" [] Decode.string


firstname : SelectionSet String GraphQL.Object.ParentProfile
firstname =
    Object.selectionForField "String" "firstname" [] Decode.string


lastname : SelectionSet String GraphQL.Object.ParentProfile
lastname =
    Object.selectionForField "String" "lastname" [] Decode.string


address : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
address =
    Object.selectionForField "(Maybe String)" "address" [] (Decode.string |> Decode.nullable)


postalCode : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
postalCode =
    Object.selectionForField "(Maybe String)" "postalCode" [] (Decode.string |> Decode.nullable)


locality : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
locality =
    Object.selectionForField "(Maybe String)" "locality" [] (Decode.string |> Decode.nullable)


country : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
country =
    Object.selectionForField "(Maybe String)" "country" [] (Decode.string |> Decode.nullable)


phone : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
phone =
    Object.selectionForField "(Maybe String)" "phone" [] (Decode.string |> Decode.nullable)


mobile : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
mobile =
    Object.selectionForField "(Maybe String)" "mobile" [] (Decode.string |> Decode.nullable)


fax : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
fax =
    Object.selectionForField "(Maybe String)" "fax" [] (Decode.string |> Decode.nullable)


email : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
email =
    Object.selectionForField "(Maybe String)" "email" [] (Decode.string |> Decode.nullable)


website : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
website =
    Object.selectionForField "(Maybe String)" "website" [] (Decode.string |> Decode.nullable)


twitter : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
twitter =
    Object.selectionForField "(Maybe String)" "twitter" [] (Decode.string |> Decode.nullable)


facebook : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
facebook =
    Object.selectionForField "(Maybe String)" "facebook" [] (Decode.string |> Decode.nullable)


instagram : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
instagram =
    Object.selectionForField "(Maybe String)" "instagram" [] (Decode.string |> Decode.nullable)


mastodon : SelectionSet (Maybe String) GraphQL.Object.ParentProfile
mastodon =
    Object.selectionForField "(Maybe String)" "mastodon" [] (Decode.string |> Decode.nullable)


family : SelectionSet decodesTo GraphQL.Object.Family -> SelectionSet decodesTo GraphQL.Object.ParentProfile
family object_ =
    Object.selectionForCompositeField "family" [] object_ identity
