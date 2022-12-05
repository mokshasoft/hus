data Payer = JC | JAD | KK
  deriving (Show)

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

main :: IO ()
main = do
  putStrLn $ "cost " ++ show (total items)
