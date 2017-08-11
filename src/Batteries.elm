module Batteries exposing (BatteryProfile, batteries_map, firstValidRange, m4_scorcher)

{-| This module contains the definitions for the various artillery pieces,
specifically their ranges and velocities equivalents for the various in-game
fire modes.
-}

import Dict exposing (fromList)


{-| The range information for a specific fire mode, for a specific battery.
-}
type alias RangeProfile =
    { min_range : Int
    , max_range : Int
    , velocity : Float
    }


{-| A particular in-game battery model (the thing that shoots)
-}
type alias BatteryProfile =
    { short : RangeProfile
    , medium : RangeProfile
    , far : RangeProfile
    , further : RangeProfile
    , extreme : RangeProfile
    , name : String
    }


m4_scorcher : BatteryProfile
m4_scorcher =
    { short = RangeProfile 826 2415 153.9
    , medium = RangeProfile 2059 6021 243.0
    , far = RangeProfile 2059 6021 243.0
    , further = RangeProfile 2059 6021 243.0
    , extreme = RangeProfile 2059 6021 243.0
    , name = "M4 Scorcher"
    }


mk6_mortar : BatteryProfile
mk6_mortar =
    { short = RangeProfile 34 499 70
    , medium = RangeProfile 139 1998 140
    , far = RangeProfile 284 4078 200
    , further = RangeProfile -1 -1 0.0
    , extreme = RangeProfile -1 -1 0.0
    , name = "Mk6 Mortar"
    }


batteries_list : List String
batteries_list =
    [ "mk6_mortar", "m4_scorcher" ]


batteries_map : Dict.Dict String BatteryProfile
batteries_map =
    Dict.fromList [ ( "mk6_mortar", mk6_mortar ), ( "m4_scorcher", m4_scorcher ) ]



{- This is really frustrating. Elm seems to lack a good way to abstract this better.

   It seems like I cannot generalize access to fields on a type. I can't pass "the
   name of the field" to a function and use it further. So, I need to create one
   "getter" (in this case, one "tester") per field. :(
-}


isRangeValid : RangeProfile -> Float -> Bool
isRangeValid range_profile range =
    (toFloat range_profile.min_range <= range) && (toFloat range_profile.max_range >= range)


isShortValid : BatteryProfile -> Float -> Bool
isShortValid profile range =
    let
        range_profile =
            profile.short
    in
    isRangeValid range_profile range


isMediumValid : BatteryProfile -> Float -> Bool
isMediumValid profile range =
    let
        range_profile =
            profile.medium
    in
    isRangeValid range_profile range


isFarValid : BatteryProfile -> Float -> Bool
isFarValid profile range =
    let
        range_profile =
            profile.far
    in
    isRangeValid range_profile range


isFurtherValid : BatteryProfile -> Float -> Bool
isFurtherValid profile range =
    let
        range_profile =
            profile.further
    in
    isRangeValid range_profile range


isExtremeValid : BatteryProfile -> Float -> Bool
isExtremeValid profile range =
    let
        range_profile =
            profile.extreme
    in
    isRangeValid range_profile range


firstValidRange : BatteryProfile -> Float -> String
firstValidRange profile range =
    if isShortValid profile range then
        "short"
    else if isMediumValid profile range then
        "medium"
    else if isFarValid profile range then
        "far"
    else if isFurtherValid profile range then
        "further"
    else if isExtremeValid profile range then
        "extreme"
    else
        "impossible"
