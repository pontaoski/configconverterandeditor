module Config.New exposing (..)

import Json.Encode as E

type AbilityTrigger
    = PlayerHurt
    | PlayerHurtPvP
    | PlayerKilled
    | PlayerKilledPvP
    | ActiveUsed
    | ProjectileShot { interval : Int }
    | IntervalElapsed { interval : Int }

encodeTrigger : AbilityTrigger -> E.Value
encodeTrigger trigger =
    E.object <|
    case trigger of
        PlayerHurt ->
            [("$type", E.string "PlayerHurt")]

        PlayerHurtPvP ->
            [("$type", E.string "PlayerHurtPvP")]

        PlayerKilled ->
            [("$type", E.string "PlayerKilled")]

        PlayerKilledPvP ->
            [("$type", E.string "PlayerKilledPvP")]

        ActiveUsed ->
            [("$type", E.string "ActiveUsed")]

        ProjectileShot { interval } ->
            [ ("$type", E.string "ProjectileShot")
            , ("interval", E.int interval)
            ]

        IntervalElapsed { interval } ->
            [ ("$type", E.string "IntervalElapsed")
            , ("interval", E.int interval)
            ]


type alias TemporaryReforge =
    { itemID : Int
    , prefix : Int
    , duration : String
    }

type alias Buff =
    { buffID : Int
    , buffDuration : Int
    }

encodeBuff : Buff -> E.Value
encodeBuff buff =
    E.object
        [ ("buff-id", E.int buff.buffID)
        , ("buff-duration", E.int buff.buffDuration)
        ]

type alias PlayerBuffer = List Buff

encodeBuffer : PlayerBuffer -> E.Value
encodeBuffer a =
    E.object [("buffs", E.list encodeBuff a)]

type alias BuffSelf =
    { buffs : PlayerBuffer
    }

type alias SpawnNPC =
    { npcID : Int
    }

type alias TemporaryItem =
    { itemID : Int
    , prefixID : Int
    , duration : String
    , isAccessory : Bool
    }

type Action
    = ATemporaryReforge TemporaryReforge
    | ABuffSelf BuffSelf
    | ASpawnNPC SpawnNPC
    | ATemporaryItem TemporaryItem

encodeAction : Action -> E.Value
encodeAction action =
    E.object <|
    case action of
        ATemporaryReforge { itemID, prefix, duration } ->
            [ ("$type", E.string "TemporaryReforge")
            , ("item-id", E.int itemID)
            , ("prefix", E.int prefix)
            , ("duration", E.string duration)
            ]

        ABuffSelf { buffs } ->
            [ ("$type", E.string "BuffSelf")
            , ("buffer", encodeBuffer buffs)
            ]

        ASpawnNPC { npcID } ->
            [ ("$type", E.string "SpawnNPC")
            , ("npc-id", E.int npcID)
            ]

        ATemporaryItem { itemID, prefixID, duration, isAccessory } ->
            [ ("$type", E.string "TemporaryItem")
            , ("item-id", E.int itemID )
            , ("prefix-id", E.int prefixID )
            , ("duration", E.string duration )
            , ("is-accessory", E.bool isAccessory)
            ]


type alias ClassAbility =
    { triggers : List AbilityTrigger
    , actions : List Action
    }

encodeAbility : ClassAbility -> E.Value
encodeAbility ability =
    E.object
        [ ("triggers", E.list encodeTrigger ability.triggers)
        , ("actions", E.list encodeAction ability.actions)
        ]

type alias ClassConfig =
    { name : String
    , inventory : String
    , abilityCooldownSeconds : Int
    , healthFromKills : Int
    , requiredPoints : Int
    , randomOnly : Bool
    , staffOnly : Bool
    , buffs : List Int
    , abilities : List ClassAbility
    }

type alias Config =
    { pointsForWinning : Int
    , pointsForLosing : Int
    , pointsForDrawing : Int
    , eventFrequencyTicks : Int
    , tikiShrineAttackRadiusTiles : Int
    , tikiShrineAttackDamage : Int
    , tikiShrineAttackSpeedTicks : Int
    , tikiShrineSelfHealSpeedTicks : Int
    , tikiHealRadiusTiles : Int
    , tikiHealSpeedTicks : Int
    , hpAsManaCost : Int
    , treePlatformConvertRadiusTiles : Float
    , classes : List ClassConfig
    }

encodeClassConfig : ClassConfig -> E.Value
encodeClassConfig config =
    E.object
        [ ( "name", E.string config.name )
        , ( "inventory", E.string config.inventory )
        , ( "ability-cooldown-seconds", E.int config.abilityCooldownSeconds )
        , ( "health-from-kills", E.int config.healthFromKills )
        , ( "required-points", E.int config.requiredPoints )
        , ( "random-only", E.bool config.randomOnly )
        , ( "staff-only", E.bool config.staffOnly )
        , ( "buffs", E.list E.int config.buffs )
        , ( "abilities", E.list encodeAbility config.abilities )
        ]

encodeConfig : Config -> E.Value
encodeConfig config =
    E.object
        [ ( "points-for-winning", E.int config.pointsForWinning)
        , ( "points-for-losing", E.int config.pointsForLosing)
        , ( "points-for-drawing", E.int config.pointsForDrawing)
        , ( "event-frequency-ticks", E.int config.eventFrequencyTicks)
        , ( "tiki-shrine-attack-radius-tiles", E.int config.tikiShrineAttackRadiusTiles)
        , ( "tiki-shrine-attack-damage", E.int config.tikiShrineAttackDamage)
        , ( "tiki-shrine-attack-speed-ticks", E.int config.tikiShrineAttackSpeedTicks)
        , ( "tiki-shrine-self-heal-speed-ticks", E.int config.tikiShrineSelfHealSpeedTicks)
        , ( "tiki-heal-radius-tiles", E.int config.tikiHealRadiusTiles)
        , ( "tiki-heal-speed-ticks", E.int config.tikiHealSpeedTicks)
        , ( "hp-as-mana-cost", E.int config.hpAsManaCost)
        , ( "tree-platform-convert-radius-tiles", E.float config.treePlatformConvertRadiusTiles )
        , ( "classes", E.list encodeClassConfig config.classes )
        ]
