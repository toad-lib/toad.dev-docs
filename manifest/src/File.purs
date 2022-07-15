module File (module FS, FileTree(..), readdirRec, modifyPath) where

import Prelude

import Control.Applicative (class Applicative)
import Data.Foldable (class Foldable, fold, foldl, foldr)
import Data.FoldableWithIndex
  ( class FoldableWithIndex
  , foldMapDefault
  , foldMapWithIndexDefaultL
  , foldlDefault
  , foldlWithIndex
  , foldrDefault
  , foldrWithIndex
  )
import Data.Functor (class Functor)
import Data.FunctorWithIndex (class FunctorWithIndex, mapDefault, mapWithIndex)
import Data.Traversable (class Traversable, sequenceDefault, traverse)
import Data.Traversable (sequence)
import Effect (Effect)
import Node.Buffer (Buffer)
import Node.FS.Stats (isFile)
import Node.FS.Sync as FS
import Node.Path (FilePath)
import Node.Path as Path

data FileTree a = Dir FilePath (Array (FileTree a)) | File FilePath a

instance mapIxFT :: FunctorWithIndex FilePath FileTree where
  mapWithIndex f (Dir p ts) = Dir p (map (mapWithIndex f) ts)
  mapWithIndex f (File p a) = File p (f p a)

instance mapFT :: Functor FileTree where
  map = mapDefault

instance foldIxFT :: FoldableWithIndex FilePath FileTree where
  foldlWithIndex f b (Dir _ ts) = foldl (foldlWithIndex f) b ts
  foldlWithIndex f b (File p a) = f p b a
  foldrWithIndex f b (Dir _ ts) = foldr (flip $ foldrWithIndex f) b ts
  foldrWithIndex f b (File p a) = f p a b
  foldMapWithIndex = foldMapWithIndexDefaultL

instance foldFT :: Foldable FileTree where
  foldl = foldlDefault
  foldr = foldrDefault
  foldMap = foldMapDefault

instance showFT :: Show a => Show (FileTree a) where
  show (Dir p ts) = fold [ "Dir ", show p, " ", show ts ]
  show (File p a) = fold [ "File ", show p, " (", show a, ")" ]

instance traverseFT :: Traversable FileTree where
  traverse f (Dir p ts) = Dir p <$> traverse (traverse f) ts
  traverse f (File p a) = File p <$> f a
  sequence = sequenceDefault

modifyPath
  :: forall f a
   . Applicative f
  => (FilePath -> f FilePath)
  -> FileTree a
  -> f (FileTree a)
modifyPath f (Dir p ts) =
  ado
    p' <- f p
    ts' <- sequence <<< map (modifyPath f) $ ts
    in Dir p' ts'
modifyPath f (File p t) =
  ado
    p' <- f p
    in File p' t

readdirRec :: FilePath -> Effect (FileTree Buffer)
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
