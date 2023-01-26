module Lib
  ( someFunc
  ) where

import Control.Monad.Writer
import Graphics.Implicit
import Graphics.Implicit.Definitions

type PartsObj3 = Writer [String] SymbolicObj3

-- Shortest brick side
bs = 0.07

brick :: SymbolicObj3
brick = cube False (V3 (2 * bs) (4 * bs) bs)

brickLift :: PartsObj3
brickLift = writer (brick, ["Add a brick"])

unionL :: [PartsObj3] -> PartsObj3
unionL [] = writer (emptySpace, [])
unionL (x:xs) = do
  m1 <- x
  mRest <- unionL xs
  writer (union [m1, mRest], [])

translateL ::
     V3 ℝ -> PartsObj3 -> PartsObj3
translateL vec wm = do
  m <- wm
  writer (translate vec m, [])

brickLayer :: PartsObj3
brickLayer =
  unionL $ [translateL (V3 (2 * 1.1 * bs * x) 0 0) brickLift | x <- [0 .. 4]]

someFunc :: IO ()
someFunc = do
  putStrLn "Generating model.stl"
  let (model, parts) = runWriter brickLayer
  putStrLn $ show parts
  writeSTL 0.01 "model.stl" model
