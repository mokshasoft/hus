module Lib
  ( someFunc
  ) where

import Graphics.Implicit
import Graphics.Implicit.Definitions
import System.TimeIt

someFunc :: IO ()
someFunc = do
  putStrLn "Generating model1.stl fast"
  timeIt $ writeSTL 1 "model1.stl" $ cube False (V3 200 95 45)
  putStrLn "Generating model2.stl slow"
  timeIt $ writeSTL 1 "model2.stl" $ cube False (V3 4000 95 45)
  putStrLn "Done"
