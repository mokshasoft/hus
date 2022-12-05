import Data.List

data Payer = JC | JAD | KK
  deriving (Show, Eq, Ord)

data Item =
  I
    { description :: String
    , cost :: Int
    , payer :: Payer
    , date :: String
    }
  deriving (Show)

page1 :: [Item]
page1 =
  [ I "4 fönster" 9500 JAD ""
  , I "3 dörrar" 900 JAD ""
  , I "byggekologibok" 1118 JAD ""
  , I "förhandsbesked" 5007 JC ""
  , I "gjutningsgrejor" 4264 JC ""
  , I "betong" 2573 JC ""
  , I "betong" 2573 JC ""
  , I "bensin elverk" 430 JC ""
  , I "betong" 581 JC ""
  , I "transport sågverk" 3750 JC ""
  , I "betong & grävning" 14424 JC ""
  , I "fönster" 5600 JC ""
  , I "15000 hos Johan i material" 15000 JAD ""
  , I "bygglov" 15337 JAD ""
  , I "BNA verktyg" 5270 JC ""
  , I "motorsåg" 697 JC ""
  , I "tegel 1/2" 4500 JAD ""
  , I "ytterdörr" 4400 JAD ""
  , I "tegel" 2700 JC ""
  , I "Håkan" 6150 JAD ""
  , I "tegel 1/2" 4500 JAD ""
  , I "diesel" 550 JC ""
  , I "BNA kablar" 1870 JC ""
  , I "ove" 2000 JC ""
  , I "thor" 2600 JC ""
  , I "byggmax" 845 JC ""
  , I "stuvbutiken" 1256 JC ""
  , I "pressenning" 3247 JC ""
  ]

page2 :: [Item]
page2 =
  [ I "thor" 6259 JC ""
  , I "ecococon 1/2" 158575 JC ""
  , I "värmandsschakt" 34015 JAD ""
  , I "bygghandel" 1076 JC ""
  , I "taisto" 1800 JC ""
  , I "isolering Bauhaus 810kg" 11166 JAD ""
  , I "isolering woodfibre" 5600 JC ""
  , I "fuktmätare" 1609 JC ""
  , I "vinschar" 1050 JC ""
  , I "lis 16" 3000 JC ""
  , I "ecococon #2" 160000 JAD ""
  , I "ecococon #2" 850 JC ""
  , I "såg" 70000 JAD ""
  , I "såg" 70000 JC ""
  , I "biltema" 934 JC ""
  , I "alex v17" 1500 JC ""
  , I "tak" 16250 JAD ""
  , I "tak förskott" 1500 JAD ""
  , I "edsvalla trä" 37592 JAD "15/5"
  , I "värmlandschakt" 10350 JAD "15/5"
  , I "bitförlängare" 347 JC ""
  , I "alex 2:a v" 700 JC ""
  , I "diesel" 491 JC ""
  , I "indianwood" 51250 JC ""
  , I "dewalt" 7739 JC ""
  , I "ales 3:dje v" 700 JC ""
  , I "karmskruv" 490 JAD "1/6"
  , I "k-rauta" 2937 JAD ""
  , I "verktygsbälte" 798 JAD ""
  , I "ecococon #3" 136973 JC ""
  , I "bits" 286 JC ""
  , I "alex 4:de v" 500 JC ""
  ]


items = page1 ++ page2

total :: [Item] -> Int
total = sum . map cost

eachTotal :: [Item] -> [(Int, Payer)]
eachTotal is = map (\i -> (total i, payer $ head i)) $ groupBy group $ sortBy order is
 where
  group = \a b -> payer a == payer b
  order = \a b -> compare (payer a) (payer b)

main :: IO ()
main = do
  putStrLn $ "cost " ++ show (total items)
  putStrLn $ "each payed " ++ show (eachTotal items)
