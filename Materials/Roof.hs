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

-- | Building elements

printRoof :: IO ()
printRoof = do
  putStrLn "-- Roof          --"
  putStrLn $ "nbr sheets main roof: " ++ show nbr
  putStrLn $ "length of sheets main roof: " ++ show len
  putStrLn $ "length of 'fotbräda' and 'pulpet nock': " ++ show fotBrada
 where
  nbr = ceiling (w / ccx)
  len = l * fromInteger nbr

-- | Run material calculation
main :: IO ()
main = do
  printRoof
