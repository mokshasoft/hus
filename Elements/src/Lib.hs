module Lib
  ( someFunc
  ) where

import Graphics.Implicit
import Graphics.Implicit.Definitions

someFunc :: IO ()
someFunc = do
  putStrLn "Generating model3.stl"
  writeSTL 1 "model3.stl" $ cube False (V3 3 0.095 0.045)
  putStrLn "Done"
