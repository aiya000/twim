module Twim.Follow where

import Twim.Config

data OperationKind = OperationKindFollower | OperationKindFollowing
  deriving (Show)

followFromUser :: OperationKind -> Config -> IO ()
followFromUser = undefined
