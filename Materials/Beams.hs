data Material =
  Material
    { cost :: Float
    , area :: Float
    , beamLength :: Float
    }
  deriving (Show)

instance Semigroup Material where
  a <> b =
    Material
      { cost = cost a + cost b
      , area = area a + area b
      , beamLength = beamLength a + beamLength b
      }

instance Monoid Material where
  mempty = Material {cost = 0, area = 0, beamLength = 0}

-- | Center-Center distances for X and Y axis in a framed structure
ccx :: Float
ccx = 0.6

ccy :: Float
ccy = 1.2

-- | Building elements
frame :: Float -> Float -> Material
frame w h =
  Material
    { cost = 0
    , area = w * h
    , beamLength =
        h * fromInteger (1 + ceiling (w / ccx)) +
        w * fromInteger (1 + ceiling (h / ccy))
    }

frame' :: Float -> Float -> Float -> Material
frame' w h1 h2 = frame w ((h1 + h2) / 2)

-- | Specific building elements
bedroom :: Material
bedroom = frame' 3.0 4.2 4.8

bathroom :: Material
bathroom = frame' 2.7 3.5 4.0 <> frame' 2.7 3.5 4.0 <> frame 2.5 4.0

loadBearingWall :: Material
loadBearingWall = frame 7500 4200

innerCeiling :: Material
innerCeiling = frame 7500 3000

gardenRoof :: Material
gardenRoof = frame 3750 2500

garageInnerRoof :: Material
garageInnerRoof = frame 6000 5000

garageWall :: Material
garageWall = frame 22000 2800

-- | Run material calculation
main :: IO ()
main = print bedroom
