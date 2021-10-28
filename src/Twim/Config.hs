module Twim.Config where

import Control.Monad.Extra
import System.EasyFile
import Twim.Twitter
import Twim.Utils

data Config = Config
  { yourId :: TwitterUserId  -- ^ Your user id
  , trustedUsers :: [TwitterUserId] -- ^ Users that you don't want to unfollow
  } deriving (Show, Read)

getConfigDirPath :: IO FilePath
getConfigDirPath = getHomeDirectory >>= pure . (<> "/.config/twim")

getConfigFilePath :: IO FilePath
getConfigFilePath = getConfigDirPath >>= pure . (<> "/config")

-- |
-- Initializes ~/.config/twim and config files under the directory.
--
-- This asks your twitter id if this app has never initialized.
initConfigDir :: IO ()
initConfigDir = do
  getConfigDirPath >>= createDirectoryIfMissing True
  putStr "Your twitter id: "
  yourId <- getLine
  let config = show $ Config yourId []
  getConfigFilePath >>= flip writeFile config

readConfig :: IO (Maybe Config)
readConfig = do
  configPath <- getConfigFilePath
  ifM (not <$> doesDirectoryExist configPath)
    do pure Nothing
    do readFileMay @Config configPath
