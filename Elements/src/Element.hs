module Element
  ( Framework(..)
  ) where

import Numeric
import Graphics.Implicit
import Graphics.Implicit.Definitions

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

-- |
class Element a where
  model :: a -> SymbolicObj3
  beams :: a -> Float

-- | Define a framework type
data Framework =
  Framework
    { cost :: Float
    , area :: Float
    , beamLength :: Float
    }
  deriving (Show)

instance Semigroup Framework where
  a <> b = undefined

instance Monoid Framework where
  mempty = undefined

