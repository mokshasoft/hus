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
newtype BeamSize =
  BeamSize (Float, Float)
  deriving (Show)

b2by4 :: BeamSize
b2by4 = (0.045, 0.095)

b2by5 :: BeamSize
b2by5 = (0.045, 0.120)

b2by6 :: BeamSize
b2by6 = (0.045, 0.145)

b2by8 :: BeamSize
b2by8 = (0.045, 0.195)

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
  Material {cost = 0, area = w * h, beamLength = w * h * (1 / wd)}

solid' :: BeamSize -> Float -> Float -> Float -> Material
solid' b w h1 h2 = solid b w ((h1 + h2) / 2)

-- | Helpers
printMaterial :: String -> Material -> IO ()
printMaterial str m = do
  putStr $ str ++ ": "
  putStrLn $ showFFloat (Just 2) (beamLength m) "m"

-- | Specific building elements
bedroom :: Material
bedroom = frame' 3.0 4.2 4.8

bathroom :: Material
bathroom = frame' 2.7 3.5 4.0 <> frame' 2.7 3.5 4.0 <> frame 2.5 4.0

loadBearingWall :: Material
loadBearingWall = frame 7.5 4.2

innerCeiling :: Material
innerCeiling = frame 7.5 3.0

gardenRoof :: Material
gardenRoof = frame 3.75 2.5

garageInnerRoof :: Material
garageInnerRoof = frame 6.0 5.0

garageWall :: Material
garageWall = frame 22.0 2.8

-- | Run material calculation
main :: IO ()
main = do
  printMaterial "bedroom:            2\"4" bedroom
  printMaterial "bathroom:           2\"4" bathroom
  printMaterial "load-bearing:       2\"5" loadBearingWall
  printMaterial "inner ceiling:      2\"5" innerCeiling
  printMaterial "winter garden roof: 2\"6" gardenRoof
  putStrLn $ "winter garden wall: 2\"6: " ++ show (11 * 3) ++ "m"
  printMaterial "garage inner roof:  2\"5" garageInnerRoof
  printMaterial "garage wall:        2\"4" garageWall
