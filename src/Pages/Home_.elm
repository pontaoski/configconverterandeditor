module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import File.Select as Select
import Element exposing (..)
import Element.Input as Input
import File exposing (File)
import Task exposing (Task)
import Json.Decode as Decode
import Config.Old as Old
import Config.New as New
import Config.Convert as Convert
import File.Download
import Json.Encode exposing (encode)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = vview
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { old : Maybe (Result Decode.Error Old.Config)
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing, Cmd.none )



-- UPDATE


type Msg
    = OpenOld
    | OldOpened File
    | DownloadNew New.Config
    | OldRead (Result Decode.Error Old.Config)


decodeFile : File -> Decode.Decoder a -> Task x (Result Decode.Error a)
decodeFile file decoder =
    File.toString file
    |> (Task.andThen <|
        \str ->
            Task.succeed (Decode.decodeString decoder str))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenOld ->
            ( model, Select.file ["application/json"] OldOpened )

        OldOpened f ->
            ( model, Task.perform OldRead (decodeFile f Old.configDecoder))

        OldRead s ->
            ( { model | old = Just s }, Cmd.none )

        DownloadNew f ->
            ( model, File.Download.string "config.json" "text/json" (encode 4 <| New.encodeConfig f) )




-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


vview : Model -> View Msg
vview model =
    View "Convertidor" <| view model

view : Model -> Element Msg
view model =
    column
        []
        [ Input.button []
            { onPress = Just OpenOld
            , label = text "load old file"
            }
        , case model.old of
            Just (Err err) ->
                text (Decode.errorToString err)

            Just (Ok f) ->
                Input.button []
                    { onPress = Just (DownloadNew (f |> Convert.oldToNew))
                    , label = text "download new file"
                    }

            Nothing ->
                none
        ]
