{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "toad-dev-docs"
, dependencies =
  [ "argonaut-core"
  , "arrays"
  , "bifunctors"
  , "codec-argonaut"
  , "console"
  , "effect"
  , "either"
  , "filterable"
  , "foldable-traversable"
  , "toad-dev"
  , "maybe"
  , "node-buffer"
  , "node-fs"
  , "node-path"
  , "node-process"
  , "ordered-collections"
  , "parsing"
  , "partial"
  , "prelude"
  , "strings"
  , "tuples"
  , "unordered-collections"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
