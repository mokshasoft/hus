import Numeric

data Window =
  W
    { width :: Float -- millimeters
    , height :: Float -- millimeters
    }
  deriving (Show)

windows :: [Window]
windows
    -- North
 =
  [ W 913 2115 -- W02
  , W 1308 1210 -- W05
  , W 1308 610 -- W08
  , W 1308 610 -- W08
    -- South
  , W 908 2010 -- W03
  , W 908 2010 -- W03
  , W 558 1040 -- W07
    -- East
  , W 558 1050 -- W06
  , W 1013 2115 -- W01
    -- West
  , W 1308 610 -- W08
  , W 908 610 -- W09
  , W 908 2010 -- W03
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
  putStrLn $ "längd: " ++ (show $ silLength windows) ++ " m"
  mapM_ (putStrLn . show . mmToM . width) windows
  putStrLn "\n"

printInsulation :: IO ()
printInsulation = do
  putStrLn "-- Drev          --"
  putStrLn $ "längd: " ++ (show $ insulationLength windows) ++ " m\n"

-- | Run material calculation
main :: IO ()
main = do
  printInsulation
  printSil
