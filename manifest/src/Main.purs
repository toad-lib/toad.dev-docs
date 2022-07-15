module Main where

import Prelude

import Data.Array (head, singleton)
import Data.Bifunctor (lmap, rmap)
import Data.Either (Either(..), either, fromRight, note)
import Data.Filterable (filter)
import Data.Foldable (fold, fold, foldl, length)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Maybe (Maybe(..))
import Data.Traversable (sequence)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (T2, T3, (/\))
import Effect (Effect)
import Effect.Console as Console
import File as File
import Kwap.Concept (Alias(..), Decl(..), Path(..), Title(..))
import Kwap.Markdown as Markdown
import Node.Buffer as Buffer
import Node.Encoding (Encoding(UTF8))
import Node.Path as Path
import Node.Process as Process
import Parsing (runParser)
import Partial.Unsafe (unsafeCrashWith)
import Pragma (Pragma(..), decodePragma, defaultPragma)

unwrap :: ∀ a. Either String a -> Effect a
unwrap = either unsafeCrashWith pure

getDocuments :: Effect (File.FileTree Markdown.Document)
getDocuments = do
  cwd <- Process.cwd
  p <- Path.resolve [ cwd ] "../concepts"
  buffers <- File.readdirRec p
  strings <- sequence <<< map (Buffer.toString UTF8) $ buffers

  unwrap
    <<< lmap show
    <<< sequence
    <<< map (flip runParser $ Markdown.documentP)
    $ strings

pragma
  :: String
  -> Markdown.Document
  -> Either String Pragma
pragma p d = case head <<< Markdown.elements $ d of
  Just (Markdown.ElementComment json) -> lmap (p <> _) $ decodePragma json
  _ -> pure defaultPragma

title :: String -> Markdown.Document -> Either String Title
title p d =
  let
    isComment (Markdown.ElementComment _) = true
    isComment _ = false

    h1Text (Markdown.ElementHeading (Markdown.H1 s)) = Just $
      Markdown.spanString s
    h1Text _ = Nothing
  in
    lmap (_ <> "\n" <> show d)
      <<< lmap (p <> _)
      <<< rmap Title
      <<< note "First non-comment element of a concept document must be an H1"
      <<< (flip bind) h1Text
      <<< head
      <<< filter (not isComment)
      <<< Markdown.elements
      $ d

manifest1 :: Pragma -> Path -> Title -> Decl
manifest1 (Pragma { alias: a }) p t = Decl
  { alias: Alias <$> a, title: t, path: p }

main :: Effect Unit
main =
  let
    buildManifest1 p d = pure manifest1 <*> pragma ("in " <> p <> ": ") d
      <*> pure (Path p)
      <*> title ("in " <> p <> ": ") d
  in
    do
      cwd <- Process.cwd
      docs <- getDocuments
      Console.log $ "[gen-manifest] " <> (show <<< (length :: _ -> Int) $ docs)
        <> " documents found"
      ms <-
        unwrap <<< map (fold <<< map singleton) <<< sequence <<< mapWithIndex
          buildManifest1 $ docs
      Console.log $ "[gen-manifest] found " <>
        (show <<< map (\(Decl { alias }) -> alias) $ ms)
      pure unit
