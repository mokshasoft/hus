import Numeric

-- | Roof dimensions
oh = 0.59
w = 8.5 + 2*oh
l = 8.3 + 2*oh

w2 = 1.7 + oh
l2 = 3.0 + 2*oh

-- | Metal roof sheets
ccx :: Float
ccx = 0.466

ccy1 :: Float
ccy1 = 3.3

ccy2 :: Float
ccy2 = 1.955

-- | Helpers

nbrBeams :: Float -> Float -> Float
nbrBeams width cc = fromInteger (1 + ceiling (width / cc))

-- | Elements

fotBrada :: Float
fotBrada = 10.2 + 2*oh

-- The number of joins needed to cover the roof north/south with the ccy1 sheets
joinsPerLine1 :: Float
joinsPerLine1 = fromInteger $ floor (l / ccy1)

-- The number of joins needed to cover the roof north/south with the ccy1+ccy2 sheets
-- These lines start with a ccy2 sheet followed by ccy1 sheets
joinsPerLine2 :: Float
joinsPerLine2 = fromInteger $ floor (leftOver / ccy1) + 1
 where
  leftOver = l - ccy2

-- | Building elements

printRoof :: IO ()
printRoof = do
  putStrLn "-- Roof          --"
  putStrLn $ "nbr sheets main roof: " ++ show nbr
  putStrLn $ "length of sheets main roof: " ++ show len
  putStrLn $ "length of 'fotbräda' and 'pulpet nock': " ++ show fotBrada
  putStrLn $ "nbr joins line1: " ++ show joinsPerLine1
  putStrLn $ "nbr joins line2: " ++ show joinsPerLine2
 where
  nbr = ceiling (w / ccx)
  len = l * fromInteger nbr

-- | Run material calculation
main :: IO ()
main = do
  printRoof
