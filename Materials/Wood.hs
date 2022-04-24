import Numeric

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

-- | Standard beams
type BeamSize = (Float, Float)

b1by4 :: BeamSize
b1by4 = (0.025, 0.100)

b2by4 :: BeamSize
b2by4 = (0.045, 0.095)

b2by5 :: BeamSize
b2by5 = (0.045, 0.120)

b2by6 :: BeamSize
b2by6 = (0.045, 0.145)

b2by8 :: BeamSize
b2by8 = (0.045, 0.195)

-- | Helpers
double :: Material -> Material
double m = m <> m

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

solid :: BeamSize -> Float -> Float -> Material
solid (th, wd) w h =
  let area = w * h
      beamLength = area / wd
   in Material {cost = 0, area = area, beamLength = beamLength}

solid' :: BeamSize -> Float -> Float -> Float -> Material
solid' b w h1 h2 = solid b w ((h1 + h2) / 2)

-- | Helpers
printMaterial :: String -> Material -> IO ()
printMaterial str m = do
  putStr $ str ++ ": "
  putStrLn $
    showFFloat (Just 2) (beamLength m) "m" ++
    ", " ++ showFFloat (Just 2) (area m) "m2"

-- | Specific building elements
bedroom :: Material
bedroom = double $ solid' b1by4 3.0 4.2 4.8

bathroom :: Material
bathroom =
  double $
  solid' b1by4 2.7 3.5 4.0 <> solid' b1by4 2.7 3.5 4.0 <> solid b1by4 2.5 4.0

loadBearingWall :: Material
loadBearingWall = frame 7.5 4.2

loadBearingWallOutside :: Material
loadBearingWallOutside = double $ solid b1by4 7.5 4.2

innerCeiling :: Material
innerCeiling = frame 7.5 3.0

-- the layers above and below the floor framework
floorLayers :: Material
floorLayers =
  let layer = solid b1by4 8.3 8.5 <> solid b1by4 3.1 1.7 <> solid b1by4 2.5 3.75
   in layer <> layer <> layer -- one layer below and two on-top

floorFramework :: Material
floorFramework =
  let w = 8.3
      h = 10.2
   in Material
        { cost = 0
        , area = 8.3 * 8.5 + 3.1 * 1.7
        , beamLength
            -- Approximate by including the entry porch
           =
            h * fromInteger (1 + ceiling (w / 0.6)) +
            w * fromInteger (1 + ceiling (h / 0.6))
        }

gardenRoof :: Material
gardenRoof = frame 3.75 2.5

garageInnerRoof :: Material
garageInnerRoof = frame 6.0 5.0

garageWall :: Material
garageWall = frame 22.0 2.8

-- | Roof
innerRoof = solid b1by4 10.2 8.3

outerRoof = solid b1by4 (10.2 + 1) (8.3 + 1)

-- | Outer wall size
outerHouseWall :: Material
outerHouseWall =
  let beam = (0.025, 0.195)
   in solid beam 10.2 4.5 <>
      solid' beam 8.3 4.5 6.0 <>
      solid beam 8.5 6.0 <>
      solid' beam 5.2 6.0 5.0 <> solid beam 1.7 5 <> solid' beam 3.1 5.0 4.5

printIndianWoods :: IO ()
printIndianWoods = do
  putStrLn "-- IndianWoods --"
  printMaterial "bedroom:              1\"4" bedroom
  printMaterial "bathroom:             1\"4" bathroom
  printMaterial "load bearing outside: 1\"4" loadBearingWallOutside
  printMaterial "floors:               1\"4" floorLayers
  printMaterial "inner roof            1\"4" innerRoof
  printMaterial "outer roof            1\"4" outerRoof
  printMaterial "total 1\"4:               " $
    bedroom <> bathroom <> loadBearingWallOutside <> floorLayers <> innerRoof <> outerRoof
  printMaterial "House panel:          1\"8" outerHouseWall
  putStrLn "-----------------"

printKH :: IO ()
printKH = do
  putStrLn "-- KH          --"
  printMaterial "load-bearing:       2\"4" loadBearingWall
  printMaterial "inner ceiling:      2\"5" innerCeiling
  printMaterial "floor framework:    2\"8" floorFramework
  putStrLn "-----------------"

-- | Run material calculation
main :: IO ()
main = do
  printIndianWoods
  printKH
