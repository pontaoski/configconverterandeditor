module Pages.Home_ exposing (Model, Msg, page)

import Classes
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import File exposing (File)
import Gen.Params.Home_ exposing (Params)
import Json.Encode exposing (encode)
import List.Extra
import Monocle.Common as Common
import Monocle.Compose as Compose
import Monocle.Lens as Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)
import Page
import Request
import Shared
import Task exposing (Task)
import View exposing (View)


ugly =
    [ padding 16, Border.color <| rgb255 0 0 0, Border.width 2, spacing 16 ]


uglyButton =
    [ padding 4
    , Border.width 1
    , Border.rounded 12
    , mouseDown
        [ Background.color <| rgb255 0 0 0
        , Font.color <| rgb255 255 255 255
        ]
    ]


name =
    Lens .name (\b a -> { a | name = b })


enableStruckPlayer =
    Lens .enableStruckPlayer (\b a -> { a | enableStruckPlayer = b })


abilities =
    Lens .abilities (\b a -> { a | abilities = b })


triggers =
    Lens .triggers (\b a -> { a | triggers = b })


actions =
    Lens .actions (\b a -> { a | actions = b })


targeter =
    Lens .targeter (\b a -> { a | targeter = b })


notifier =
    Lens .notifier (\b a -> { a | notifier = b })


soundPlayer =
    Lens .soundPlayer (\b a -> { a | soundPlayer = b })


lBase =
    Lens .base (\b a -> { a | base = b })


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
    { config : List Classes.ClassConfig
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        [ { abilityCooldownSeconds = 0
          , onlyOneAbilityUseBeforeDeath = False
          , cooldownPenaltyPerExtraPlayers = 0
          , name = "Your Mom"
          , inventory = "yourmom"
          , requiredPoints = 50
          , randomOnly = False
          , staffOnly = False
          , buffs = []
          , abilities =
                [ { triggers = [ Classes.ActiveUsed ]
                  , actions =
                        [ Classes.AHurt
                            { base = Classes.ActionBase Nothing Nothing Classes.TTargetSelf
                            , damage = 50
                            }
                        ]
                  }
                ]
          , icon = 50
          , tags = []
          , enableStruckPlayer = False
          , harpCooldown = Nothing
          , bellCooldown = Nothing
          , whistleCooldown = Nothing
          , summary = ""
          , description = ""
          }
        ]
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateClassList (List Classes.ClassConfig)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateClassList newList ->
            ( { model | config = newList }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


vview : Model -> View Msg
vview model =
    View "Convertidor" <| view model


type alias Viewer ofType =
    List Classes.ClassConfig -> Optional (List Classes.ClassConfig) ofType -> ofType -> Element Msg


set val classes =
    \opt ->
        opt.set val
            |> (\it ->
                    it classes
                        |> UpdateClassList
               )


viewTargeter : Viewer Classes.Targeter
viewTargeter classes optional item =
    column []
        [ Input.radio ugly
            { onChange =
                \opt ->
                    optional.set opt classes
                        |> UpdateClassList
            , options =
                [ Input.option (Classes.TTargetRadius { targetTypes = "", radius = 0 }) (text "Everyone In Radius")
                , Input.option (Classes.TTargetType { targetTypes = "" }) (text "Everyone Of Type")
                , Input.option Classes.TTargetTriggerTarget (text "Trigger")
                , Input.option Classes.TTargetSelf (text "Self")
                ]
            , selected = Just item
            , label = Input.labelAbove [] (text "Target")
            }
        ]


viewNotifier : Viewer Classes.Notifier
viewNotifier classes optional item =
    Debug.todo "a"


viewSoundPlayer : Viewer Classes.SoundPlayer
viewSoundPlayer classes optional item =
    Debug.todo "a"


viewOptionalNotifier : Viewer (Maybe Classes.Notifier)
viewOptionalNotifier classes optional item =
    case item of
        Nothing ->
            Input.button uglyButton
                { onPress = Just (UpdateClassList <| optional.set (Just (Classes.Notifier "#fffffff" Nothing Nothing Nothing Nothing)) classes)
                , label = text "Add Notifier"
                }

        Just it ->
            column []
                [ text "Notifier"
                , column ugly []
                ]


viewOptionalSoundPlayer : Viewer (Maybe Classes.SoundPlayer)
viewOptionalSoundPlayer classes optional item =
    case item of
        Nothing ->
            Input.button uglyButton
                { onPress = Nothing
                , label = text "Add Sound Player"
                }

        Just it ->
            Debug.todo "a"


viewActionBase : Viewer Classes.ActionBase
viewActionBase classes optional item =
    row []
        [ viewOptionalNotifier classes (optional |> Compose.optionalWithLens notifier) item.notifier
        , viewOptionalSoundPlayer classes (optional |> Compose.optionalWithLens soundPlayer) item.soundPlayer
        , viewTargeter classes (optional |> Compose.optionalWithLens targeter) item.targeter
        ]


viewAction : Viewer Classes.Action
viewAction classes optional item =
    let
        baseLens =
            optional |> Compose.optionalWithOptional Classes.baseLens
    in
    case item of
        Classes.ABeginDuel action ->
            Debug.todo "a"

        Classes.ABuff action ->
            Debug.todo "a"

        Classes.AExplode action ->
            Debug.todo "a"

        Classes.AGive action ->
            Debug.todo "a"

        Classes.AGiveFromBag action ->
            Debug.todo "a"

        Classes.AHeal action ->
            Debug.todo "a"

        Classes.AHurt { base, damage } ->
            column ugly
                [ text "Hurt Target"
                , Input.text ugly
                    { onChange = \msg -> Debug.todo "a"
                    , text = String.fromInt damage
                    , placeholder = Nothing
                    , label = Input.labelAbove [] (text "Damage")
                    }
                , viewActionBase classes baseLens base
                ]

        Classes.AMessage action ->
            Debug.todo "a"

        Classes.ANPC action ->
            Debug.todo "a"

        Classes.ARemoveShotProjectile action ->
            Debug.todo "a"

        Classes.ASound action ->
            Debug.todo "a"

        Classes.ASpawnProjectile action ->
            Debug.todo "a"

        Classes.ASwap action ->
            Debug.todo "a"

        Classes.ASwapOnHitWithProjectile action ->
            Debug.todo "a"

        Classes.ATemporaryEnableStruckPlayer action ->
            Debug.todo "a"

        Classes.ATemporaryItem action ->
            Debug.todo "a"

        Classes.ATemporaryReforge action ->
            Debug.todo "a"

        Classes.OPause action ->
            Debug.todo "a"

        Classes.ORepeat action ->
            Debug.todo "a"

        Classes.ORunAfter action ->
            Debug.todo "a"

        Classes.ORunAtMost action ->
            Debug.todo "a"

        Classes.ORunOnIntervalFor action ->
            Debug.todo "a"

        Classes.ORunParallel action ->
            Debug.todo "a"

        Classes.ORunRandom action ->
            Debug.todo "a"

        Classes.ORunSequentially action ->
            Debug.todo "a"


viewTrigger : Viewer Classes.AbilityTrigger
viewTrigger classes optional item =
    el ugly <|
        Input.radio ugly
            { onChange =
                \opt ->
                    optional.set opt classes
                        |> UpdateClassList
            , options =
                [ Input.option Classes.PlayerHurt (text "Player Hurt")
                , Input.option Classes.PlayerHurtPvP (text "Player Hurt PvP")
                , Input.option Classes.PlayerKilled (text "Player Killed")
                , Input.option Classes.PlayerKilledPvP (text "Player Killed PvP")
                , Input.option Classes.ActiveUsed (text "Whoopie Used")
                , Input.option (Classes.ProjectileShot { interval = 0 }) (text "Projectile Shot")
                , Input.option (Classes.IntervalElapsed { interval = 0 }) (text "Interval Elapsed")
                ]
            , selected = Just item
            , label = Input.labelAbove [] (text "Trigger")
            }



-- case item of
--     Classes.PlayerHurt ->
--         Debug.todo "a"
--     Classes.PlayerHurtPvP ->
--         Debug.todo "a"
--     Classes.PlayerKilled ->
--         Debug.todo "a"
--     Classes.PlayerKilledPvP ->
--         Debug.todo "a"
--     Classes.ActiveUsed ->
--         Debug.todo "a"
--     Classes.ProjectileShot { interval } ->
--         Debug.todo "a"
--     Classes.IntervalElapsed { interval } ->
--         Debug.todo "a"


mapNestedViewer : a -> Optional c b -> (a -> Optional c d -> e -> f) -> List e -> Lens b (List d) -> List f
mapNestedViewer classes optional viewer list lens =
    List.indexedMap
        (\idx item ->
            viewer classes (optional |> nested lens idx) item
        )
        list


viewAbility : Viewer Classes.ClassAbility
viewAbility classes optional item =
    column ugly
        (text "Actions"
            :: mapNestedViewer classes optional viewAction item.actions actions
            ++ text "Triggers"
            :: mapNestedViewer classes optional viewTrigger item.triggers triggers
        )


nested : Lens b (List a) -> Int -> Optional c b -> Optional c a
nested lens idx optional =
    optional
        |> Compose.optionalWithLens lens
        |> Compose.optionalWithOptional (Common.list idx)


viewItem : Viewer Classes.ClassConfig
viewItem classes optional item =
    column ugly
        ([ Input.text ugly
            { onChange =
                \str ->
                    optional
                        |> Compose.optionalWithLens name
                        |> set str classes
            , text = item.name
            , placeholder = Nothing
            , label = Input.labelAbove [] (text "Class Name")
            }
         , Input.checkbox []
            { onChange =
                \newValue ->
                    optional
                        |> Compose.optionalWithLens enableStruckPlayer
                        |> set newValue classes
            , icon = Input.defaultCheckbox
            , checked = item.enableStruckPlayer
            , label = Input.labelAbove [] (text "Enable StruckPlayer abilities")
            }
         ]
            ++ mapNestedViewer classes optional viewAbility item.abilities abilities
        )


view : Model -> Element Msg
view model =
    column [ padding 8 ]
        (List.indexedMap
            (\idx item ->
                viewItem model.config (Common.list idx) item
            )
            model.config
        )
