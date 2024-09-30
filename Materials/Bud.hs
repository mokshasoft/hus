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
  , I "stuv" 507 JC "9/5"
  , I "elmaterial" 3877 JC "9/5"
  , I "isolerglas" 3500 JC "13/5"
  , I "isolerglas x4" 2000 JC "13/5"
  , I "vikfönster" 18000 JC "14/5"
  , I "kamitak" 12341 JC "15/5"
  , I "vattenrör" 2763 JC "15/5"
  , I "golvvärme" 23459 JC "15/5"
  , I "flexrör" 700 JC "17/5"
  ]

page6 :: [Item]
page6 =
  [ I "avgift miljö & bygg" 4400 JAD "19/5"
  , I "fasadfärg" 18375 JAD "19/5"
  , I "avlopp" 55000 JAD "29/5"
  , I "avlopp" 36261 JC "29/5"
  , I "hyvelspån" 1855 JC "30/5"
  , I "bits" 388 JC "5/6"
  , I "elmaterial" 2875 JC "9/6"
  , I "murhinkar" 1119 JC "9/6"
  , I "handskar" 339 JC "9/6"
  , I "brunn, pump" 38669 JC "12/6"
  , I "hönsnät" 1197 JC "11/6"
  , I "diesel" 483 JC "11/6"
  , I "AsCy" 3754 JC "15/6"
  , I "sand" 12826 JC "15/6"
  , I "diesel" 486 JC "16/6"
  , I "fönster" 7500 JC "25/6"
  , I "armering jute" 2845 JAD "27/6"
  , I "väg gemensam" 4361 JAD "juni-23"
  , I "spån" 374 JC "27/6"
  , I "takdosor" 90 JC "30/6"
  , I "kontroll Håkan" 4700 JC "1/7"
  , I "kuskhuset" 6609 JAD "28/6"
  , I "spån" 1812 JC "13/7"
  , I "diesel" 420 JC "13/7"
  , I "fibercementskiva" 1100 JC "16/7"
  , I "spån" 525 JC "18/7"
  , I "badkar" 300 JAD "12/7"
  , I "badkar" 700 JC "14/7"
  , I "tak/golv" 8400 JC "25/7"
  , I "el" 12331 JC "25/7"
  ]

page7 :: [Item]
page7 =
  [ I "vik" 600 JC "26/7"
  , I "el mtrl" 994 JC "30/7"
  , I "Dan" 3000 JC "1/8"
  , I "Bjarne" 12000 JC "1/8"
  , I "Björn" 10000 JAD "1/8"
  , I "stuv" 475 JC "3/8"
  , I "diesel" 198 JC "11/8"
  , I "diesel" 210 JC "18/8"
  , I "skottskärra" 500 JC "18/8"
  , I "BNA" 5930 JC "24/8"
  , I "kh" 11602 JAD "3/9"
  , I "tejp" 330 JC "23/8"
  , I "diesel" 233 JC "30/8"
  , I "tejp" 660 JC "5/9"
  , I "isoleko" 47600 JAD "11/9"
  , I "stuv-dusch" 7500 JAD "17/9"
  , I "betong" 328 JC "25/9"
  , I "roller" 180 JC "10/10"
  , I "diesel" 405 JC "13/10"
  , I "djupvattenpump" 5000 JC "15/10"
  , I "pem slag" 500 JC "15/10"
  , I "" 9000 JAD "17/10"
  , I "" 31778 JAD "18/10"
  , I "skorsten" 6563 JC "23/10"
  , I "spis" 1500 JAD "1/11"
  , I "skorstens isolering" 990 JAD "?/10"
  , I "vvs" 3795 JC "31/10"
  , I "stuv" 943 JC "17/10"
  , I "isolering" 1425 JC "23/10"
  , I "tejp" 209 JC "1/11"
  , I "p-strip" 190 JC "31/10"
  ]

page8 :: [Item]
page8 =
  [ I "altandörr förskott" 500 JC "16/11"
  , I "altandörr" 2500 JAD "16/11"
  , I "släp" 1170 JAD "16/11"
  , I "med" 2600 JAD "17/10"
  , I "vik" 500 JC "20/11"
  , I "sjunktimmer" 6200 JC "23/11"
  , I "släp" 350 JC "23/11"
  , I "sim" 1000 JC "8/12"
  , I "edsvalla" 37763 JC "26/12"
  , I "multiblad" 369 JC "3/1"
  , I "bauhaus" 4652 JC "6/1"
  , I "pardörr" 8000 JC "14/1"
  , I "fönster" 6000 JC "14/1"
  , I "släp" 230 JC "14/1"
  , I "panna" 5000 JAD "27/1"
  , I "panna" 10000 JC "27/1"
  , I "släp" 250 JC "27/1"
  , I "IBC" 1400 JC "27/1"
  , I "flytt panna" 7794 JAD "10/2"
  , I "spik" 489 JC "6/3"
  , I "hönsnät" 1323 JC "6/3"
  , I "skorstenshuv" 5396 JAD "6/3"
  , I "ytterdörr" 3990 JC "7/3"
  , I "svanströms" 263 JC "7/3"
  , I "KH" 782 JC "14/3"
  , I "kaminlucka" 6509 JC "30/3"
  , I "sjunktimmer" 2000 JC "13/4"
  , I "KH" 303 JC "19/4"
  , I "Bauhaus" 437 JC "27/4"
  , I "Bauhaus" 1198 JAD "27/4"
  , I "golvskruv" 364 JC "21/5"
  , I "AsCy" 5649 JC "26/5"
  ]

page9 :: [Item]
page9 =
  [ I "batterikablar" 1521 JC "30/5"
  , I "stuv" 665 JC "12/6"
  , I "Byggmax" 398 JC "30/5"
  , I "häftklamrar" 329 JAD "29/6"
  , I "linolja" 2141 JC "4/7"
  , I "DC-kablar" 1144 JAD "?/6"
  , I "bensin" 99 JC "1/7"
  , I "vindpapp" 725 JC "4/7"
  , I "organowood" 779 JC "3/7"
  , I "betong" 4250 JC "5/7"
  , I "bensin" 100 JC "11/7"
  , I "borrhammare" 1500 JC "15/7"
  , I "eldkraft" 1240 JC "20/7"
  , I "säkring" 209 JC "22/7"
  , I "byggmax" 411 JAD "22/7"
  , I "vitvaror" 10799 JAD "15/7"
  , I "cirkelsåg" 2475 JC "13/7"
  , I "termometer" 129 JAD "30/7"
  , I "Le Tonkinois" 888 JAD "30/7"
  , I "Grävning Benjamin" 3610 JAD "9/8"
  , I "timer" 149 JC "17/8"
  , I "isoleringsjobb" 27498 JAD "27/8"
  , I "Bauhaus" 946 JAD "26/8"
  , I "Linolja" 548 JAD "26/8"
  , I "VVS butiken" 4489 JAD "13/8"
  , I "Murhinkar" 392 JC "14/9"
  , I "Lampa" 353 JC "14/9"
  , I "linolja 20l" 2063 JAD "30/9"
  ]

items = page1 ++ page2 ++ page3 ++ page4 ++ page5 ++ page6 ++ page7 ++ page8 ++ page9

total :: [Item] -> Int
total = sum . map cost

eachTotal :: [Item] -> [(Int, Payer)]
eachTotal is =
  map (\i -> (total i, payer $ head i)) $ groupBy group $ sortBy order is
  where
    group a b = payer a == payer b
    order a b = compare (payer a) (payer b)

main :: IO ()
main = do
  putStrLn $ "cost " ++ show (total items)
  putStrLn $ "each payed " ++ show (eachTotal items)
