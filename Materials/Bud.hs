import Data.List

data Payer
  = JC
  | JAD
  | KK
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

page3 :: [Item]
page3 =
  [ I "lantmäteriet lagfart" 825 JAD "8/6"
  , I "lindtech (takplåt)" 23998 JAD "8/6"
  , I "perkolationstest" 594 JC "10/6"
  , I "varbergsträ (fönster)" 23354 JAD "14/6"
  , I "lis 3,3" 340 JAD ""
  , I "karl hedin" 480 JC "17/6"
  , I "spik" 817 JC ""
  , I "diesel" 430 JC "27/6"
  , I "bits" 195 JC ""
  , I "aur 25" 3000 JC ""
  , I "aur 27" 4500 JC ""
  , I "aur 26" 500 JC ""
  , I "värdering" 4000 JC "15/7"
  , I "spik" 1944 JC "16/7"
  , I "diesel" 470 JC "17/7"
  , I "diesel" 531 JC "20/7"
  , I "diesel" 432 JC ""
  , I "i-beams" (-545) JC ""
  , I "stuv tjära mm" 744 JAD "25/7"
  , I "edsvallaträ" 29500 JAD "27/7"
  , I "aur 1.5" 140 JAD ""
  , I "mat kollektiv" 1000 JAD ""
  , I "thor" 2711 JC "31/7"
  , I "BNA åter" (-3680) JC "18/10"
  , I "aur" 12350 JC "4/8"
  , I "taklyft KH" 5231 JC "10/8"
  , I "fuktmätare" (-1609) JC "10/8"
  , I "karmskruv mm" 1363 JC "15/8"
  , I "bits jula" (-347) JC "23/8"
  , I "m bv" 1900 JAD ""
  , I "isoleringslandslaget" 9735 JAD "25/8"
  ]

page4 :: [Item]
page4 =
  [ I "edsvalla trä" 13470 JAD "27/8"
  , I "dörr" 3000 JC "4/9"
  , I "låskista" 150 JC "4/9"
  , I "spik" 1239 JC "5/9"
  , I "m bv" 1700 JAD ""
  , I "lantmäteriet" 3000 JAD "10/9"
  , I "sandprov" 182 JC "20/9"
  , I "l" 1000 JC "26/9"
  , I "spik" 1176 JC "27/9"
  , I "l bv" 5375 JAD "7/10"
  , I "jula" 1395 JC "19/10"
  , I "biltema" 3501 JC "19/10"
  , I "aur" 1000 JC "22/10"
  , I "biltema vvs" 3500 JC "24/20"
  , I "indanwood" 38500 KK "24/10"
  , I "lindtech" 1575 JC "31/10"
  , I "lindtech" 1067 JC "31/10"
  , I "aur" 3500 JC "5/11"
  , I "bj" 11500 JC "8/11"
  , I "värmlandsschakt" 36500 KK "8/11"
  , I "värmlandsschakt" 12609 JC "8/11"
  , I "isolering" 3395 JC "13/11"
  , I "imkanal" 6547 JC "13/11"
  , I "värmlandsschakt" 8750 JAD "14/11"
  , I "diesel" 518 JC "22/11"
  , I "joc" 1000 JC "4/12"
  , I "biltema" 1988 JC "3/12"
  , I "traktorspegel" 425 JC "5/12"
  , I "verktyg" 5508 JC "5/12"
  , I "svetsgas" 1581 JC "5/12"
  , I "musfälla" 1377 JC "8/12"
  , I "insektsnät" 674 JC "9/12"
  , I "Lindtech" 1800 JAD "17/12"
  , I "lumppapp" 558 JC "3/1"
  ]

page5 :: [Item]
page5 =
  [ I "sågspån mm" 2766 JC "28/1"
  , I "fuktmätare" 518 JC "16/2"
  , I "drev" 1459 JC "16/2"
  , I "libv" 3549 JAD "26/1"
  , I "ottossons färg" 374 JAD "18/2"
  , I "deposition kök" 2000 JAD "24/2"
  , I "kennet" 5000 JC "8/3"
  , I "kennet" 5000 JAD ""
  , I "släp" 519 JC "19/3"
  , I "bensin" 1696 JC "19/3"
  , I "bauhaus" 1363 JC "19/3"
  , I "handfat" 100 JC "19/3"
  , I "kök" 10000 JC "19/3"
  , I "ottossons färg" 1683 JAD "27/3"
  , I "malin" 400 JAD "27/3"
  , I "eldningsfat" 1100 JC "1/4"
  , I "betongblandare" 249 JC "31/3"
  , I "tegelsten" 4725 JC "1/4"
  , I "förskott blandare" 3000 JAD "4/4"
  , I "blandare" 12000 JC "7/4"
  , I "innerdörrar" 15170 JC "12/4"
  , I "takskruv" 600 JAD "22/4"
  , I "solceller" 151363 JC "29/4"
  ]

items = page1 ++ page2 ++ page3 ++ page4 ++ page5

total :: [Item] -> Int
total = sum . map cost

eachTotal :: [Item] -> [(Int, Payer)]
eachTotal is =
  map (\i -> (total i, payer $ head i)) $ groupBy group $ sortBy order is
  where
    group = \a b -> payer a == payer b
    order = \a b -> compare (payer a) (payer b)

main :: IO ()
main = do
  putStrLn $ "cost " ++ show (total items)
  putStrLn $ "each payed " ++ show (eachTotal items)
