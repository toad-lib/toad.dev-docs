module Main where

import Prelude

import Data.Array (head, singleton)
import Data.Bifunctor (lmap, rmap)
import Data.Either (Either(..), either, fromRight, note)
import Data.Filterable (filter)
import Data.Foldable (fold, foldl, length)
import Data.FoldableWithIndex (foldlWithIndex)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Map as Map
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.Pattern (Pattern(..), Replacement(..))
import Data.Traversable (sequence)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (T2, T3, (/\))
import Effect (Effect)
import Effect.Console as Console
import File as File
import Toad.Concept (Manifest(..), Decl(..), Ident(..), Path(..), Title(..), encodeManifest)
import Toad.Markdown as Md
import Node.Buffer as Buffer
import Node.Encoding (Encoding(UTF8))
import Node.Path as Path
import Node.Process as Process
import Parsing (runParser)
import Partial.Unsafe (unsafeCrashWith)
import Pragma (Pragma(..), decodePragma, defaultPragma)

unwrap :: ∀ a. Either String a -> Effect a
unwrap = either unsafeCrashWith pure

getDocuments :: Effect (File.FileTree Md.Document)
getDocuments = do
  cwd <- Process.cwd
  p <- Path.resolve [ cwd ] "../concepts"
  buffers <- File.readdirRec p
  strings <- sequence <<< map (Buffer.toString UTF8) $ buffers

  unwrap
    <<< lmap show
    <<< sequence
    <<< map (flip runParser $ Md.documentP)
    $ strings

pragma
  :: String
  -> Md.Document
  -> Either String Pragma
pragma p d = case head <<< Md.elements $ d of
  Just (Md.ElementComment json) -> lmap (p <> _) $ decodePragma json
  _ -> pure defaultPragma

title :: String -> Md.Document -> Either String Title
title p d =
  let
    isComment (Md.ElementComment _) = true
    isComment _ = false

    h1Text (Md.ElementHeading (Md.H1 s)) = Just $ Md.spanString s
    h1Text _ = Nothing
  in
    lmap (_ <> "\n" <> show d)
      <<< lmap (p <> _)
      <<< rmap Title
      <<< note "First non-comment element of a concept document must be an H1"
      <<< (flip bind) h1Text
      <<< head
      <<< filter (not isComment)
      <<< Md.elements
      $ d

decl :: Pragma -> Path -> Title -> Decl
decl (Pragma { ident: i }) p@(Path ps) t =
  let
    identDefault = String.replace (Pattern ".md") (Replacement "") ps
  in
    Decl
      { ident: Ident (fromMaybe identDefault i)
      , title: t
      , path: p
      }

main :: Effect Unit
main =
  let
    log = ("[gen-manifest] " <> _) >>> Console.log

    buildDecl p d =
      pure decl
        <*> pragma ("in " <> p <> ": ") d
        <*> pure (Path p)
        <*> title ("in " <> p <> ": ") d

    relpath p = do
      cwd <- Process.cwd
      concepts <- Path.resolve [ cwd ] "../concepts"
      pure $ Path.relative concepts p
  in
    do
      docs <- getDocuments
      log $ show (length docs :: Int) <> " documents found"
      docs' <- File.modifyPath relpath $ docs
      decls <-
        unwrap
          <<< map (fold <<< map singleton)
          <<< sequence
          <<< mapWithIndex buildDecl
          $ docs'
      log
        <<< ("idents:" <> _)
        <<< fold
        <<< map ("\n * " <> _)
        <<< map (\(Decl { ident }) -> show ident)
        $ decls

      cwd <- Process.cwd
      manifestLoc <- Path.resolve [cwd] "../concepts.json"

      File.writeTextFile UTF8 manifestLoc <<< encodeManifest <<< Manifest $ decls
      pure unit
