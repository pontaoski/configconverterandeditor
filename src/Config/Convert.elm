module Config.Convert exposing (..)

import Dict
import Config.Old as Old
import Config.New as New

toFrames : Int -> Int
toFrames milliseconds =
    milliseconds // 17

oldClassToNew : Old.Config -> String -> String -> Int -> List Int -> (List New.ClassAbility) -> New.ClassConfig
oldClassToNew old name num defaultCooldown defaultBuffs abilities =
    { name = name
    , inventory = String.replace "#" num old.inventoryFormat
    , abilityCooldownSeconds = Dict.get name old.classAbilityCooldownsSeconds |> Maybe.withDefault defaultCooldown
    , healthFromKills = 0
    , requiredPoints = 0
    , randomOnly = False
    , staffOnly = False
    , buffs = Dict.get name old.classBuffs |> Maybe.withDefault defaultBuffs
    , abilities = abilities
    }

oldArcherToNew : Old.Config -> New.ClassConfig
oldArcherToNew old =
    oldClassToNew old
        "Archer" "0" 35 [36]
        [ New.ClassAbility
            [ New.ActiveUsed ]
            [ New.ATemporaryReforge
                { itemID = 265
                , prefix = 18
                , duration = "00:00:0" ++ (String.fromInt (old.archerAbilityDurationMilliseconds // 1000))
                }
            , New.ABuffSelf
                { buffs = [ New.Buff 16 (toFrames old.archerAbilityDurationMilliseconds) ]
                }
            ]
        ]

oldNinjaToNew : Old.Config -> New.ClassConfig
oldNinjaToNew old =
    oldClassToNew old
        "Ninja" "1" 20 [158, 6]
        [ New.ClassAbility
            [ New.ActiveUsed ]
            [ New.ABuffSelf { buffs = [ New.Buff 10 old.ninjaAbilityDurationFrames ]}
            ]
        ]

oldBeastToNew : Old.Config -> New.ClassConfig
oldBeastToNew old =
    oldClassToNew old
        "Beast" "2" 35 []
        [ New.ClassAbility
            [ New.ActiveUsed ]
            [ New.ASpawnNPC { npcID = 141 }
            ]
        ]

oldGladiatorToNew : Old.Config -> New.ClassConfig
oldGladiatorToNew old =
    oldClassToNew old
        "Gladiator" "3" 40 [33]
        [ New.ClassAbility
            [ New.ActiveUsed ]
            [ New.ATemporaryItem
                { itemID = 4788
                , prefixID = 50
                , duration = "00:00:0" ++ (String.fromInt (old.gladiatorAbilityDurationMilliseconds // 1000))
                , isAccessory = False
                }
            , New.ABuffSelf
                { buffs =
                    [ { buffID = 3, buffDuration = toFrames old.gladiatorAbilityDurationMilliseconds }
                    , { buffID = 146 , buffDuration = toFrames old.gladiatorAbilityDurationMilliseconds }
                    ]
                }
            ]
        ]

oldTankToNew : Old.Config -> New.ClassConfig
oldTankToNew old =
    oldClassToNew old
        "Tank" "4" 40 [46]
        [ New.ClassAbility
            [ New.ActiveUsed ]
            [ New.ABuffSelf
                { buffs =
                    [ { buffID = 5, buffDuration = old.tankAbilityDurationFrames }
                    , { buffID = 113 , buffDuration = old.tankAbilityDurationFrames }
                    , { buffID = 114 , buffDuration = old.tankAbilityDurationFrames }
                    ]
                }
            ]
        ]

-- TODO: ABILITY
oldJungleManToNew : Old.Config -> New.ClassConfig
oldJungleManToNew old =
    oldClassToNew old
        "Jungle Man" "5" 35 [33]
        [ New.ClassAbility
            [ New.ActiveUsed ]
            [ New.ABuffSelf
                { buffs =
                    [ { buffID = 5, buffDuration = old.tankAbilityDurationFrames }
                    , { buffID = 113 , buffDuration = old.tankAbilityDurationFrames }
                    , { buffID = 114 , buffDuration = old.tankAbilityDurationFrames }
                    ]
                }
            ]
        ]

oldBlackMageToNew = oldArcherToNew
oldPsychicToNew = oldArcherToNew
oldFemaleWhiteMageToNew = oldArcherToNew
oldMinerToNew = oldArcherToNew
oldFishToNew = oldArcherToNew
oldClownToNew = oldArcherToNew
oldFlameBunnyToNew = oldArcherToNew
oldTikiToNew = oldArcherToNew
oldTreeToNew = oldArcherToNew
oldMutantToNew = oldArcherToNew

oldToNew : Old.Config -> New.Config
oldToNew old =
    { pointsForWinning = old.pointsForWinning
    , pointsForLosing = old.pointsForLosing
    , pointsForDrawing = old.pointsForDrawing
    , eventFrequencyTicks = old.eventFrequencyTicks
    , tikiShrineAttackRadiusTiles = old.tikiShrineAttackRadiusTiles
    , tikiShrineAttackDamage = old.tikiShrineAttackDamage
    , tikiShrineAttackSpeedTicks = old.tikiShrineAttackSpeedTicks
    , tikiShrineSelfHealSpeedTicks = old.tikiShrineSelfHealSpeedTicks
    , tikiHealRadiusTiles = old.tikiHealRadiusTiles
    , tikiHealSpeedTicks = old.tikiHealSpeedTicks
    , hpAsManaCost = old.psychicAbilitySelfDamage
    , treePlatformConvertRadiusTiles = old.treePlatformConvertRadiusTiles
    , classes =
        [ oldArcherToNew old
        , oldNinjaToNew old
        , oldBeastToNew old
        , oldGladiatorToNew old
        , oldTankToNew old
        , oldJungleManToNew old
        , oldBlackMageToNew old
        , oldPsychicToNew old
        , oldFemaleWhiteMageToNew old
        , oldMinerToNew old
        , oldFishToNew old
        , oldClownToNew old
        , oldFlameBunnyToNew old
        , oldTikiToNew old
        , oldTreeToNew old
        , oldMutantToNew old
        ]
    }