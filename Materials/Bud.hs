import Data.List

data Payer = JC | JAD | KK
  deriving (Show, Eq)

data Item =
  I
    { description :: String
    , cost :: Int
    , payer :: Payer
    , date :: String
    }
  deriving (Show)

items :: [Item]
items =
  [ I "" 1 JC ""
  , I "" 2 JC ""
  , I "" 4 JAD ""
  ]

total :: [Item] -> Int
total = sum . map cost

eachTotal :: [Item] -> [(Int, Payer)]
eachTotal is = map (\i -> (total i, payer $ head i)) $ groupBy (\a b -> payer a == payer b) is

main :: IO ()
main = do
  putStrLn $ "cost " ++ show (total items)
  putStrLn $ "each payed " ++ show (eachTotal items)
