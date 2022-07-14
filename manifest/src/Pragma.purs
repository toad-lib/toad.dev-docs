module Pragma where

import Prelude

import Data.Argonaut.Core (jsonNull) as Text.Json
import Data.Argonaut.Parser (jsonParser) as Text.Json
import Data.Bifunctor (lmap)
import Data.Codec.Argonaut
  ( JsonCodec
  , array
  , decode
  , printJsonDecodeError
  , string
  ) as Text.Json
import Data.Codec.Argonaut ((>~>))
import Data.Codec.Argonaut.Compat (maybe) as Text.Json
import Data.Codec.Argonaut.Migration (addDefaultField) as Text.Json
import Data.Codec.Argonaut.Record (object) as Text.Json
import Data.Either (Either)
import Data.Maybe (Maybe)

newtype Pragma = Pragma { alias :: Maybe String }

pragmaCodec
  :: Text.Json.JsonCodec { alias :: Maybe String }
pragmaCodec = Text.Json.addDefaultField "alias" Text.Json.jsonNull
  >~> Text.Json.object "Pragma"
    { alias: Text.Json.maybe Text.Json.string
    }

decodePragma :: String -> Either String Pragma
decodePragma s = do
  json <- Text.Json.jsonParser s
  pragma <- lmap Text.Json.printJsonDecodeError $ Text.Json.decode
    pragmaCodec
    json
  pure <<< Pragma $ pragma
