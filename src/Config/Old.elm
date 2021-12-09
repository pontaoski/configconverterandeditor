module Config.Old exposing (..)

import Dict exposing (Dict)

import Json.Decode as Decode exposing (Decoder, int, string, float, list, dict)
import Json.Decode.Pipeline exposing (required, optional)

type alias Item =
    { itemID : Int
    , prefixID : Int
    }

itemDecoder : Decoder Item
itemDecoder =
    Decode.succeed Item
        |> required "item-id" int
        |> optional "prefix-id" int 0

type alias MutantItems =
    { maxHP : Int
    , currentHPMultipier : Float
    , weapon : Item
    , accessories : List Item
    , vanity : List Item
    }

mutantItemsDecoder : Decoder MutantItems
mutantItemsDecoder =
    Decode.succeed MutantItems
        |> required "max-hp" int
        |> required "current-hp-multiplier" float
        |> required "weapon" itemDecoder
        |> required "accessories" (list itemDecoder)
        |> required "vanity" (list itemDecoder)


type alias Config =
    { pointsForWinning : Int
    , pointsForLosing : Int
    , pointsForDrawing : Int
    , inventoryFormat : String
    , classBuffs : Dict String (List Int)
    , eventFrequencyTicks : Int
    , passiveAbilityFrequencyTicks : Int
    , classAbilityCooldownsSeconds : Dict String Int
    , archerAbilityDurationMilliseconds : Int
    , ninjaAbilityDurationFrames : Int
    , gladiatorAbilityDurationMilliseconds : Int
    , tankAbilityDurationFrames : Int
    , jungleManAbilityRadiusTiles : Int
    , jungleManAbilityDurationMilliseconds : Int
    , jungleManDebuffDurationFrames : Int
    , blackMageAbilityDurationFrames : Int
    , psychicAbilitySelfDamage : Int
    , whiteMageAbilityRadiusTiles : Int
    , whiteMageAbilityDurationFrames : Int
    , whiteMageIronskinDurationFrames : Int
    , whiteMagePassiveRadiusTiles : Int
    , whiteMagePassiveDurationFrames : Int
    , fishAbilityDurationFrames : Int
    , clownAbilityRadiusTiles : Int
    , clownAbilityDurationFrames : Int
    , clownAbilityHealPercentage : Float
    , clownMaxHp : Int
    , flameBunnyAbilityDurationMilliseconds : Int
    , flameBunnyAbilityRadiusTiles : Int
    , flameBunnyNebulaDurationFrames : Int
    , flameBunnyBuffDurationFrames : Int
    , flameBunnyDebuffDurationFrames : Int
    , tikiShrineAttackRadiusTiles : Int
    , tikiShrineAttackDamage : Int
    , tikiShrineAttackSpeedTicks : Int
    , tikiShrineSelfHealSpeedTicks : Int
    , tikiShrineMaxHp : Int
    , tikiAbilityCooldownPenaltySeconds : Int
    , tikiHealRadiusTiles : Int
    , tikiHealSpeedTicks : Int
    , treePlatformConvertRadiusTiles : Float
    , mutantAbilityDebuffDurationMilliseconds : Int
    , mutantAbilityPotionSicknessDurationFrames : Int
    , mutantItems : Dict String MutantItems
    }

configDecoder : Decoder Config
configDecoder =
    Decode.succeed Config
        |> required "points-for-winning" int
        |> required "points-for-losing" int
        |> required "points-for-drawing" int
        |> required "inventory-format" string
        |> required "class-buffs" (dict (list int))
        |> required "event-frequency-ticks" int
        |> required "passive-ability-frequency-ticks" int
        |> required "class-ability-cooldowns-seconds" (dict int)
        |> required "archer-ability-duration-milliseconds" int
        |> required "ninja-ability-duration-frames" int
        |> required "gladiator-ability-duration-milliseconds" int
        |> required "tank-ability-duration-frames" int
        |> required "jungle-man-ability-radius-tiles" int
        |> required "jungle-man-ability-duration-milliseconds" int
        |> required "jungle-man-debuff-duration-frames" int
        |> required "black-mage-ability-duration-frames" int
        |> required "psychic-ability-self-damage" int
        |> required "white-mage-ability-radius-tiles" int
        |> required "white-mage-ability-duration-frames" int
        |> required "white-mage-ironskin-duration-frames" int
        |> required "white-mage-passive-radius-tiles" int
        |> required "white-mage-passive-duration-frames" int
        |> required "fish-ability-duration-frames" int
        |> required "clown-ability-radius-tiles" int
        |> required "clown-ability-duration-frames" int
        |> required "clown-ability-heal-percentage" float
        |> required "clown-max-hp" int
        |> required "flame-bunny-ability-duration-milliseconds" int
        |> required "flame-bunny-ability-radius-tiles" int
        |> required "flame-bunny-nebula-duration-frames" int
        |> required "flame-bunny-buff-duration-frames" int
        |> required "flame-bunny-debuff-duration-frames" int
        |> required "tiki-shrine-attack-radius-tiles" int
        |> required "tiki-shrine-attack-damage" int
        |> required "tiki-shrine-attack-speed-ticks" int
        |> required "tiki-shrine-self-heal-speed-ticks" int
        |> required "tiki-shrine-max-hp" int
        |> required "tiki-ability-cooldown-penalty-seconds" int
        |> required "tiki-heal-radius-tiles" int
        |> required "tiki-heal-speed-ticks" int
        |> required "tree-platform-convert-radius-tiles" float
        |> required "mutant-ability-debuff-duration-milliseconds" int
        |> required "mutant-ability-potion-sickness-duration-frames" int
        |> required "mutant-items" (dict mutantItemsDecoder)