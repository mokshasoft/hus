import Numeric

data Window =
  W
    { width :: Float -- millimeters
    , height :: Float -- millimeters
    }
  deriving (Show)

doors :: [Window]
doors
    -- North
 =
  [ W 913 2115 -- W02
    -- South
  , W 908 2010 -- W03
    -- East
  , W 1013 2115 -- W01
    -- West
  , W 908 2010 -- W03
  ]

windows :: [Window]
windows
    -- North
 =
  [ W 1308 1210 -- W05
  , W 1308 610 -- W08
  , W 1308 610 -- W08
    -- South
  , W 908 2010 -- W03
  , W 558 1040 -- W07
    -- East
  , W 558 1050 -- W06
    -- West
  , W 1308 610 -- W08
  , W 908 610 -- W09
  , W 1808 1210 -- W04
  ]

mmToM :: Float -> Float
mmToM f = f / 1000

insulationLength :: [Window] -> Float
insulationLength = mmToM . sum . map wl
  where
    wl :: Window -> Float
    wl w = 2 * ((width w) + (height w))

silLength :: [Window] -> Float
silLength = mmToM . sum . map width

printSil :: IO ()
printSil = do
  putStrLn "-- Fönsterbrädor --"
  putStrLn $ "längd: " ++ (show $ silLength silOpenings) ++ " m"
  mapM_
    ((\s -> putStrLn $ s ++ " mm") . show . (\w -> (width w) - 5))
    silOpenings
  putStrLn "\n"
  where
    silOpenings = windows ++ [last doors]

printInsulation :: IO ()
printInsulation = do
  putStrLn "-- Drev          --"
  putStrLn $ "längd: " ++ (show $ insulationLength (windows ++ doors)) ++ " m\n"

-- | Run material calculation
main :: IO ()
main = do
  printInsulation
  printSil
