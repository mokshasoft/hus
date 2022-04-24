module Lib
  ( someFunc
  ) where

import Graphics.Implicit
import Graphics.Implicit.Definitions
import Element

model = union [cube False (pure 20), translate (pure 20) $ sphere 15]

someFunc :: IO ()
someFunc = do
  putStrLn "Generating model.stl"
  writeSTL 1 "model.stl" model

data ConfigBeam =
  ConfigBeam
    { thickness :: Double
    , width :: Double
    }
  deriving (Show)

data ConfigCc =
  ConfigCc
    { x :: Double
    , y :: Double
    }
  deriving (Show)


defaultBeam :: ConfigBeam
defaultBeam = ConfigBeam 0.045 0.095

beam :: ConfigBeam -> Double -> SymbolicObj3
beam cfgBeam length =
  cube False (V3 length (width cfgBeam) (thickness cfgBeam))

wall :: ConfigBeam -> ConfigCc -> Double -> Double -> SymbolicObj3
wall cfgBeam cfgCc width height = undefined
