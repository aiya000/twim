module Twim.Cache where

import System.EasyFile
import Twim.Twitter

newtype Cache = Cache
  { alreadyFollowedUsers :: [TwitterUserId] -- ^ Users that you already have followed
  } deriving (Show, Read)

getCacheDirPath :: IO FilePath
getCacheDirPath = getHomeDirectory >>= pure . (<> "/.cache/twim")

getCacheFilePath :: IO FilePath
getCacheFilePath = getCacheDirPath >>= pure . (<> "/cache")

-- | Initializes ~/.cache/twim and cache files under the directory.
initCacheDir :: IO ()
initCacheDir = do
  getCacheDirPath >>= createDirectoryIfMissing True
  let cache = show $ Cache []
  getCacheFilePath >>= flip writeFile cache
