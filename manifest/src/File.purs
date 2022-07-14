module File (module FS, FileTree(..), readdirRec) where

import Prelude

import Data.Foldable (fold)
import Data.Traversable (sequence)
import Effect (Effect)
import Node.Buffer (Buffer)
import Node.FS.Stats (isFile)
import Node.FS.Sync as FS
import Node.Path (FilePath)
import Node.Path as Path

-- laveen sister 602 605 8060
-- * desert art  623 877 1088
-- alta vista    602 277 1464

data FileTree = Dir FilePath (Array FileTree) | File FilePath Buffer

instance showFT :: Show FileTree where
  show (Dir p ts) = fold [ "Dir ", show p, " (", show ts, ")" ]
  show (File p b) = fold [ "File ", show p, " <Buffer>" ]

readdirRec :: FilePath -> Effect FileTree
readdirRec p =
  let
    pChild = Path.concat <<< ([ p ] <> _) <<< pure
  in
    do
      s <- FS.stat p
      if isFile s then
        map (File p) <<< FS.readFile $ p
      else do
        ps <- FS.readdir p
        map (Dir p) <<< sequence <<< map (readdirRec <<< pChild) $ ps
