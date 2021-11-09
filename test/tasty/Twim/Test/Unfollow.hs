module Twim.UnfollowTest where

import Test.Tasty (TestTree)
import Test.Tasty.HUnit ((@?=), Assertion, testCase, assertFailure)
import Twim.Cache
import Twim.TwitterApi

mockEnv :: TwimEnv
mockEnv = TwimEnv {..}
  where
    envCache = Cache []
    envConfig = undefined

test_unfollow :: [TestTree]
test_unfollow =
  [ testCase "" $ undefined -- do runViaMock $ unfollow @ViaMock
  ]
