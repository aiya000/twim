module Twim.Config where

import Control.Exception.Safe
import Control.Monad.Extra
import Data.String.Here (i)
import Safe
import System.Directory

data Config = Config
  { twitterUserId :: String
  } deriving (Show, Read)

configDir :: FilePath
configDir = "~/.config/twim"

configFile :: FilePath
configFile = [i|${configDir :: String}/config|]

-- | Initializes ~/.config/twim and config files under the directory.
initConfigDir :: IO ()
initConfigDir =
  whenM (not <$> doesDirectoryExist configDir)
    do createDirectory configDir

readConfig :: IO (Maybe Config)
readConfig = do
  config <- readFile configFile `catch` \e -> fail $ show (e :: SomeException)
  pure $ readMay @Config config
