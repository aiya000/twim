-- |
-- Running contexts.
-- Please also see 'Twim.Follow' and 'Twim.Unfollow'.
module Twim.TwitterApi where

import Control.Monad.Reader
import Control.Monad.Writer
import Twim.Config
import Twim.Twitter

-- | To inject below instance types into contexts.
class Monad m => TwitterApi m where
  followUser :: TwitterUserId -> m ()
  unfollowUser :: TwitterUserId -> m ()
  doesFollowMe :: TwitterUserId -> m Bool
  -- vvv helpers
  putLog :: String -> m ()
  printLog :: Show a => a -> m ()

-- | For actual operations.
newtype ViaNetwork a = ViaNetwork
  { unViaNetwork :: ReaderT Config IO a
  }
  deriving (Functor, Applicative, Monad)
  deriving newtype (MonadIO)

runViaNetwork :: Config -> ViaNetwork a -> IO a
runViaNetwork config = flip runReaderT config . unViaNetwork

instance TwitterApi ViaNetwork where
  followUser = undefined
  unfollowUser = undefined
  doesFollowMe = undefined
  putLog = liftIO . putStrLn
  printLog = liftIO . print

type Log = String

-- | For tests.
newtype ViaMock a = ViaMock
  { runViaMock :: ReaderT Config (Writer Log) a
  }
  deriving (Functor, Applicative, Monad)
  deriving newtype (MonadReader Config, MonadWriter Log)

instance TwitterApi ViaMock where
  followUser = undefined
  unfollowUser = undefined
  doesFollowMe = undefined
  putLog = tell
  printLog = putLog . show
