import Numeric

-- | Roof dimensions
oh = 0.59

w = 8.5 + 2 * oh

l = 8.3 + 2 * oh

w2 = 1.7 + oh

l2 = 3.0 + 2 * oh

w3 = 4.2

l3 = 3.2

-- | Metal roof sheets
ccx :: Float
ccx = 0.466

ccy1 :: Float
ccy1 = 3.3

ccy2 :: Float
ccy2 = 1.955

ccSparX :: Float
ccSparX = 0.6

ccSparY :: Float
ccSparY = 0.35

-- | Helpers
nbrBeams :: Float -> Float -> Float
nbrBeams width cc = fromInteger (1 + ceiling (width / cc))

-- | Elements
linesBigRoof :: Float
linesBigRoof = nbrBeams w ccx

linesSmallRoof :: Float
linesSmallRoof = nbrBeams w2 ccx

fotBrada :: Float
fotBrada = 10.2 + 2 * oh

-- The number of joins needed to cover the roof north/south with the ccy1 sheets
joinsPerLine1 :: Float
joinsPerLine1 = fromInteger $ floor (l / ccy1)

-- The number of joins needed to cover the roof north/south with the ccy1+ccy2 sheets
-- These lines start with a ccy2 sheet followed by ccy1 sheets
joinsPerLine2 :: Float
joinsPerLine2 = fromInteger $ floor (leftOver / ccy1) + 1
  where
    leftOver = l - ccy2

-- note: No joins needed over the bathroom
joins :: Float
joins = (joinsPerLine1 + joinsPerLine2) * nbrBeams w (2 * ccx)

spikTatningsband :: Float
spikTatningsband =
  l * nbrBeams w ccSparX + l2 * nbrBeams w2 ccSparX + l3 * nbrBeams w3 ccSparX

-- Läkt
lakt :: Float
lakt = spikTatningsband + w * nbrBeams l ccSparY + w2 * nbrBeams l2 ccSparY

-- | Building elements
printRoof :: IO ()
printRoof = do
  putStrLn "-- Roof          --"
  putStrLn $ "nbr lines main roof: " ++ show (linesBigRoof + linesSmallRoof)
  putStrLn $
    "total number of 3.3 sheets main roof:" ++
    show ((3 * linesBigRoof) + linesSmallRoof)
  putStrLn $ "length of 'fotbräda' and 'pulpet nock': " ++ show fotBrada
  putStrLn $ "gavelbeslag: " ++ show (2 * w)
  putStrLn $ "spiktätningsband: " ++ show spikTatningsband
  putStrLn $ "läkt: " ++ show lakt
  putStrLn $ "nbr joins line1: " ++ show joinsPerLine1
  putStrLn $ "nbr joins line2: " ++ show joinsPerLine2
  putStrLn $ "nbr joins total: " ++ show joins

-- | Run material calculation
main :: IO ()
main = do
  printRoof
