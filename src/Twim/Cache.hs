module Twim.Cache where

import Control.Monad.Extra
import System.EasyFile
import Twim.Twitter
import Twim.Utils

newtype Cache = Cache
  { alreadyFollowedUsers :: [TwitterUserId] -- ^ Users that you already have followed
  } deriving (Show, Read, Eq)

getCacheDirPath :: IO FilePath
getCacheDirPath = getHomeDirectory >>= pure . (<> "/.cache/twim")

getCacheFilePath :: IO FilePath
getCacheFilePath = getCacheDirPath >>= pure . (<> "/cache")

-- | Initializes ~/.cache/twim and cache files under the directory.
initCacheIfNotExistent :: IO ()
initCacheIfNotExistent = do
  getCacheDirPath >>= createDirectoryIfMissing True
  filePath <- getCacheFilePath
  whenM (not <$> doesFileExist filePath) $
    writeFile filePath empty
  where
    empty = show $ Cache []

readCache :: IO (Maybe Cache)
readCache = do
  cachePath <- getCacheFilePath
  ifM (doesFileExist cachePath)
    do readFileMay @Cache cachePath
    do pure Nothing
