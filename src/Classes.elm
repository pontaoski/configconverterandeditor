module Classes exposing (..)

import Monocle.Common as Common
import Monocle.Compose as Compose
import Monocle.Lens as Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)


type alias Named t =
    { t | name : String }


extract : Named t -> Named t
extract t =
    t


type alias TimeSpan =
    String


type AbilityTrigger
    = PlayerHurt
    | PlayerHurtPvP
    | PlayerKilled
    | PlayerKilledPvP
    | ActiveUsed
    | ProjectileShot { interval : Int }
    | IntervalElapsed { interval : Int }


type alias Notifier =
    { color : String
    , itemID : Maybe Int
    , selfMessage : Maybe String
    , targetMessage : Maybe String
    , popupMessage : Maybe String
    }


type alias SoundPlayer =
    { sounds : List String
    }


type alias IsAction t =
    { t
        | base : ActionBase
    }


type alias IsAbilityCooldown t =
    { t
        | abilityCooldownSeconds : Int
        , onlyOneAbilityUseBeforeDeath : Bool
        , cooldownPenaltyPerExtraPlayers : Int
    }


type alias TargetType =
    { targetTypes : String
    }


type alias TargetRadius =
    { targetTypes : String
    , radius : Int
    }


type Targeter
    = TTargetRadius TargetRadius
    | TTargetType TargetType
    | TTargetSelf
    | TTargetTriggerTarget


type alias ActionBase =
    { notifier : Maybe Notifier
    , soundPlayer : Maybe SoundPlayer
    , targeter : Targeter
    }


defaultBase : ActionBase
defaultBase =
    { notifier = Nothing
    , soundPlayer = Nothing
    , targeter = TTargetSelf
    }


type alias PlayerBuff =
    { buffID : Int
    , buffDuration : Int
    }


type alias PlayerBuffer =
    { buffs : List PlayerBuff
    }


type alias BasicProjectileSpawner =
    { projectiles : List Int
    , repetitions : Int
    }


type alias ProjectileVector =
    { id : Int
    , x : Int
    , y : Int
    , velocityX : Int
    , velocityY : Int
    , lifetime : Maybe TimeSpan
    }


type alias FancyProjectileSpawner =
    { projectiles : List ProjectileVector
    , repetitions : Int
    }


type ProjectileSpawner
    = PFancyProjectileSpawner FancyProjectileSpawner
    | PProjectileSpawner BasicProjectileSpawner


type alias BeginDuel =
    { deathNotifier : Maybe Notifier
    , deathSoundPlayer : Maybe SoundPlayer
    , deathProjectileSpawner : Maybe ProjectileSpawner
    , winnerBuffer : Maybe PlayerBuffer
    }


type alias Buff =
    { base : ActionBase
    , buffer : PlayerBuffer
    }


type alias Explode =
    { base : ActionBase
    }


type alias GiveItem =
    { itemID : Int
    , count : Int
    , prefix : Int
    }


type alias Give =
    { base : ActionBase
    , items : List GiveItem
    }


type PermutationMode
    = None
    | Shuffle


type alias EndlessBag t =
    { items : List t
    , permuteMode : PermutationMode
    }


type alias GiveFromBag =
    { base : ActionBase
    , bag : EndlessBag GiveItem
    }


type alias Heal =
    { base : ActionBase
    , health : Int
    }


type alias Hurt =
    { base : ActionBase
    , damage : Int
    }


type alias Message =
    { base : ActionBase
    }


type alias NPC =
    { base : ActionBase
    , npcID : Int
    }


type alias RemoveShotProjectile =
    {}


type alias Sound =
    { base : ActionBase
    }


type alias SpawnProjectile =
    { base : ActionBase
    , projectileSpawner : ProjectileSpawner
    }


type alias Swap =
    { base : ActionBase
    , targeterB : Targeter
    , healAPercentage : Maybe Float
    , healBPercentage : Maybe Float
    , aBuffer : Maybe PlayerBuffer
    , bBuffer : Maybe PlayerBuffer
    }


type alias SwapOnHitWithProjectile =
    { projectileID : Int
    }


type alias TemporaryEnableStruckPlayer =
    { base : ActionBase
    , duration : TimeSpan
    }


type alias TemporaryInventory =
    { base : ActionBase
    , inventory : String
    , duration : TimeSpan
    }


type alias TemporaryItem =
    { base : ActionBase
    , itemID : Int
    , prefix : Int
    , duration : TimeSpan
    , isAccessory : Bool
    }


type alias TemporaryReforge =
    { base : ActionBase
    , itemID : Int
    , prefix : Int
    , duration : TimeSpan
    }


type alias Pause =
    { duration : TimeSpan
    }


type alias Repeat =
    { times : Int
    , interval : TimeSpan
    , action : Action
    }


type alias RunAfter =
    { duration : Int
    , action : Action
    }


type alias RunAtMost =
    { maximumTimesRan : Int
    , action : Action
    }


type alias RunOnIntervalFor =
    { interval : TimeSpan
    , duration : TimeSpan
    , action : Action
    }


type alias RunParallel =
    { actions : List Action
    }


type alias RunRandom =
    { actions : List Action
    }


type alias RunSequentially =
    { actions : List Action
    }


type Action
    = ABeginDuel BeginDuel
    | ABuff Buff
    | AExplode Explode
    | AGive Give
    | AGiveFromBag GiveFromBag
    | AHeal Heal
    | AHurt Hurt
    | AMessage Message
    | ANPC NPC
    | ARemoveShotProjectile RemoveShotProjectile
    | ASound Sound
    | ASpawnProjectile SpawnProjectile
    | ASwap Swap
    | ASwapOnHitWithProjectile SwapOnHitWithProjectile
    | ATemporaryEnableStruckPlayer TemporaryEnableStruckPlayer
    | ATemporaryItem TemporaryItem
    | ATemporaryReforge TemporaryReforge
    | OPause Pause
    | ORepeat Repeat
    | ORunAfter RunAfter
    | ORunAtMost RunAtMost
    | ORunOnIntervalFor RunOnIntervalFor
    | ORunParallel RunParallel
    | ORunRandom RunRandom
    | ORunSequentially RunSequentially


defaultABeginDuel : Action
defaultABeginDuel =
    ABeginDuel
        { deathNotifier = Nothing
        , deathSoundPlayer = Nothing
        , deathProjectileSpawner = Nothing
        , winnerBuffer = Nothing
        }


defaultABuff : Action
defaultABuff =
    ABuff
        { base = defaultBase
        , buffer = PlayerBuffer []
        }


defaultAExplode : Action
defaultAExplode =
    AExplode
        { base = defaultBase
        }


defaultAGive : Action
defaultAGive =
    AGive
        { base = defaultBase
        , items = []
        }


defaultAGiveFromBag : Action
defaultAGiveFromBag =
    AGiveFromBag
        { base = defaultBase
        , bag = EndlessBag [] Shuffle
        }


defaultAHeal : Action
defaultAHeal =
    AHeal
        { base = defaultBase
        , health = 0
        }


defaultAHurt : Action
defaultAHurt =
    AHurt
        { base = defaultBase
        , damage = 0
        }


defaultAMessage : Action
defaultAMessage =
    AMessage
        { base = defaultBase
        }

defaultANPC : Action
defaultANPC =
    ANPC
        { base = defaultBase
        , npcID = 0
        }


defaultARemoveShotProjectile : Action
defaultARemoveShotProjectile =
    ARemoveShotProjectile
        {
        }

defaultASound : Action
defaultASound =
    ASound
        { base = defaultBase
        }

defaultASpawnProjectile : Action
defaultASpawnProjectile =
    ASpawnProjectile
        { base = defaultBase
        , projectileSpawner = PProjectileSpawner (BasicProjectileSpawner [] 0)
        }

defaultASwap : Action
defaultASwap =
    ASwap
        { base = defaultBase
        , targeterB = TTargetSelf
        , healAPercentage = Nothing
        , healBPercentage = Nothing
        , aBuffer = Nothing
        , bBuffer = Nothing
        }

defaultASwapOnHitWithProjectile : Action
defaultASwapOnHitWithProjectile =
    ASwapOnHitWithProjectile
        { projectileID = 0
        }

defaultATemporaryEnableStruckPlayer : Action
defaultATemporaryEnableStruckPlayer =
    ATemporaryEnableStruckPlayer
        { base = defaultBase
        , duration = "00:00"
        }

defaultATemporaryItem : Action
defaultATemporaryItem =
    ATemporaryItem
        { base = defaultBase
        , itemID = 0
        , prefix = 0
        , duration = "00:00"
        , isAccessory = False
        }

defaultATemporaryReforge : Action
defaultATemporaryReforge =
    ATemporaryReforge
        { base = defaultBase
        , duration = "00:00"
        , itemID = 0
        , prefix = 0
        }

defaultOPause : Action
defaultOPause =
    OPause
        { duration = "00:00"
        }


defaultORepeat : Action
defaultORepeat =
    ORepeat
        { times = 0
        , interval = "00:00"
        , action = defaultABeginDuel
        }


defaultORunAfter : Action
defaultORunAfter =
    ORunAfter
        { duration = 0
        , action = defaultABeginDuel
        }


defaultORunAtMost : Action
defaultORunAtMost =
    ORunAtMost
        { maximumTimesRan = 0
        , action = defaultABeginDuel
        }


defaultORunOnIntervalFor : Action
defaultORunOnIntervalFor =
    ORunOnIntervalFor
        { interval = "00:00"
        , duration = "00:00"
        , action = defaultABeginDuel
        }


defaultORunParallel : Action
defaultORunParallel =
    ORunParallel
        { actions = []
        }


defaultORunRandom : Action
defaultORunRandom =
    ORunRandom
        { actions = []
        }


defaultORunSequentially : Action
defaultORunSequentially =
    ORunSequentially
        { actions = []
        }

baseLens : Optional Action ActionBase
baseLens =
    { getOption =
        \action ->
            case action of
                ABeginDuel _ ->
                    Nothing

                ABuff ability ->
                    Just ability.base

                AExplode ability ->
                    Just ability.base

                AGive ability ->
                    Just ability.base

                AGiveFromBag ability ->
                    Just ability.base

                AHeal ability ->
                    Just ability.base

                AHurt ability ->
                    Just ability.base

                AMessage ability ->
                    Just ability.base

                ANPC ability ->
                    Just ability.base

                ARemoveShotProjectile _ ->
                    Nothing

                ASound ability ->
                    Just ability.base

                ASpawnProjectile ability ->
                    Just ability.base

                ASwap ability ->
                    Just ability.base

                ASwapOnHitWithProjectile _ ->
                    Nothing

                ATemporaryEnableStruckPlayer ability ->
                    Just ability.base

                ATemporaryItem ability ->
                    Just ability.base

                ATemporaryReforge ability ->
                    Just ability.base

                OPause _ ->
                    Nothing

                ORepeat _ ->
                    Nothing

                ORunAfter _ ->
                    Nothing

                ORunAtMost _ ->
                    Nothing

                ORunOnIntervalFor _ ->
                    Nothing

                ORunParallel _ ->
                    Nothing

                ORunRandom _ ->
                    Nothing

                ORunSequentially _ ->
                    Nothing
    , set =
        \base action ->
            case action of
                ABeginDuel _ ->
                    action

                ABuff ability ->
                    ABuff { ability | base = base }

                AExplode ability ->
                    AExplode { ability | base = base }

                AGive ability ->
                    AGive { ability | base = base }

                AGiveFromBag ability ->
                    AGiveFromBag { ability | base = base }

                AHeal ability ->
                    AHeal { ability | base = base }

                AHurt ability ->
                    AHurt { ability | base = base }

                AMessage ability ->
                    AMessage { ability | base = base }

                ANPC ability ->
                    ANPC { ability | base = base }

                ARemoveShotProjectile _ ->
                    action

                ASound ability ->
                    ASound { ability | base = base }

                ASpawnProjectile ability ->
                    ASpawnProjectile { ability | base = base }

                ASwap ability ->
                    ASwap { ability | base = base }

                ASwapOnHitWithProjectile _ ->
                    action

                ATemporaryEnableStruckPlayer ability ->
                    ATemporaryEnableStruckPlayer { ability | base = base }

                ATemporaryItem ability ->
                    ATemporaryItem { ability | base = base }

                ATemporaryReforge ability ->
                    ATemporaryReforge { ability | base = base }

                OPause _ ->
                    action

                ORepeat _ ->
                    action

                ORunAfter _ ->
                    action

                ORunAtMost _ ->
                    action

                ORunOnIntervalFor _ ->
                    action

                ORunParallel _ ->
                    action

                ORunRandom _ ->
                    action

                ORunSequentially _ ->
                    action
    }


type alias ClassAbility =
    { triggers : List AbilityTrigger
    , actions : List Action
    }


type alias AbilityCooldown =
    { abilityCooldownSeconds : Int
    , onlyOneAbilityUseBeforeDeath : Bool
    , cooldownPenaltyPerExtraPlayers : Int
    }


type alias ClassConfig =
    { abilityCooldownSeconds : Int
    , onlyOneAbilityUseBeforeDeath : Bool
    , cooldownPenaltyPerExtraPlayers : Int
    , name : String
    , inventory : String
    , requiredPoints : Int
    , randomOnly : Bool
    , staffOnly : Bool
    , buffs : List Int
    , abilities : List ClassAbility
    , icon : Int
    , tags : List String
    , enableStruckPlayer : Bool
    , harpCooldown : Maybe AbilityCooldown
    , bellCooldown : Maybe AbilityCooldown
    , whistleCooldown : Maybe AbilityCooldown
    , summary : String
    , description : String
    }
