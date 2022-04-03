module Lib
  ( someFunc
  ) where

import Graphics.Implicit
import Graphics.Implicit.Definitions

model = union [cube False (pure 20), translate (pure 20) $ sphere 15]

someFunc :: IO ()
someFunc = do
  putStrLn "Generating model.stl"
  writeSTL 1 "model.stl" model
