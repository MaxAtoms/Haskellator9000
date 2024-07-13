{-# LANGUAGE TemplateHaskell #-}

module Math.SiConverter.Internal.Units where

import Math.SiConverter.Internal.TH.UnitGeneration (Quantity (..), UnitDef (..),
           generateUnits)

$(generateUnits
  [ Quantity (UnitDef "Multiplier" "" 1) [], -- Unitless unit
    Quantity (UnitDef "Meter" "m" 1) -- Length
    [ UnitDef "Kilometer" "km" 1000
    , UnitDef "Centimeter" "cm" 0.01
    , UnitDef "Millimeter" "mm" 0.001
    , UnitDef "Micrometer" "µm" 1e-6
    , UnitDef "Nanometer" "nm" 1e-9
    --, UnitDef "Picometer" "pm" 1e-12
    --, UnitDef "Femtometer" "fm" 1e-15
    --, UnitDef "Attometer" "am" 1e-18
    --, UnitDef "Zeptometer" "zm" 1e-21
    --, UnitDef "Yoctometer" "ym" 1e-24
    ]
  , Quantity (UnitDef "Second" "s" 1) -- Time
    [ UnitDef "Minute" "min" 60
    , UnitDef "Hour" "h" 3600
    , UnitDef "Day" "d" 86400
    , UnitDef "Millisecond" "ms" 1e-3
    , UnitDef "Microsecond" "µs" 1e-6
    , UnitDef "Nanosecond" "ns" 1e-9
    --, UnitDef "Picosecond" "ps" 1e-12
    --, UnitDef "Femtosecond" "fs" 1e-15
    --, UnitDef "Attosecond" "as" 1e-18
    --, UnitDef "Zeptosecond" "zs" 1e-21
    --, UnitDef "Yoctosecond" "ys" 1e-24
    ]
  , Quantity (UnitDef "Kilogram" "kg" 1) -- Mass
    [ UnitDef "Tonne" "t" 1000,
      UnitDef "Gram" "g" 1e-3
    , UnitDef "Milligram" "mg" 1e-6
    , UnitDef "Microgram" "µg" 1e-9
    , UnitDef "Nanogram" "ng" 1e-12
    --, UnitDef "Picogram" "pg" 1e-15
    --, UnitDef "Femtogram" "fg" 1e-18
    --, UnitDef "Attogram" "ag" 1e-21
    --, UnitDef "Zeptogram" "zg" 1e-24
    --, UnitDef "Yoctogram" "yg" 1e-27
    ]
  ])
