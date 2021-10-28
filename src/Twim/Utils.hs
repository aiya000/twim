module Twim.Utils where

import Control.Exception.Safe
import Data.String.Here (i)
import Safe

-- | Safely reads a file content.
readFileMay :: Read a => FilePath -> IO (Maybe a)
readFileMay file = do
  content <- readFile file `catch` throwFatal file
  pure $ readMay content
  where
    throwFatal :: FilePath -> SomeException -> IO a
    throwFatal f e =
      fail [i|Fatal error! couldn't read file '${f}': ${e}|]
