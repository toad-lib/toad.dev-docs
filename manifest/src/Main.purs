module Main where

import Prelude

import Data.Either (Either(..), either, fromRight)
import Effect (Effect)
import Effect.Console as Console
import File as File
import Node.Path as Path
import Partial.Unsafe (unsafeCrashWith)

unwrap :: forall a. Either String a -> Effect a
unwrap = either unsafeCrashWith pure

main :: Effect Unit
main = do
  p <- Path.resolve [] "../concepts"
  files <- File.readdirRec p
  Console.log $ show files
