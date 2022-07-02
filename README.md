# kwap-docs
Static content served by www.kwap.rs

# Structure
`/book` contains the pages of "the kwap book" which is the multi-language
living documentation for kwap and its APIs.

`/concepts` contains zettelkasten-style atomic notes that reference one another,
that may be viewed on their own or in the context of the book.

# Markdown
Do not use the following markdown features (_unsupported by the markdown parser `kwap-rs` uses_):
- ul / ol
- anchor tags not of the form `[text](uri)` (except the special "concept" syntax)
- tables

## Link to Concepts
```
[option](@coap_option)
```
will be expanded to a link with the text "option" to `concept/coap_option.md`.

## Code samples
code fences' language tag should be of this form:

```
kwap/{platform}^{package-version}
```

where `{platform}` is one of:
```
rust
rust_embedded

java

swift

javascript
typescript
purescript
```

`{package-version}` is the major version number of the `kwap`
package in that platform's ecosystem.

in this form, the code sample will only be rendered in `kwap-rs`
when the user is viewing `kwap-rs` in that mode,
and they will be run as automated tests.

e.g. for the following markdown: (_ignore the spaces between the backticks, that's just to get it to render properly on github_)
```
` ` `rust
fn main() {
  println!("foot");
}
` ` `
` ` `kwap/javascript^1
console.log("foo");
` ` `
` ` `kwap/javascript^2
import Console from 'fancy-logging-lib';
Console.log("foo");
` ` `
` ` `kwap/rust^1
fn main() {
  println!("foo");
}
` ` `
```

All users will see the first code sample, because it's just a plain
`rust` code sample.

Users who are viewing the JS platform at version 1.0.0 will see code sample 2 but not 3, etc.

Users viewing the book on a platform that does not have a code sample will see a small warning
saying something like "sorry, we don't have a code sample for this yet :cry:".

to prevent them from being cluttered with boilerplate,
you may (judiciously) omit code from code samples by
commenting lines with `--`.
These lines will still be included in the automated tests,
but hidden on `kwap-rs`.

```
` ` `kwap/javascript^2
-- const foo = 12;
if (foo + 12 !== 24) {
  throw new Error('foo should be 12');
}
` ` `
` ` `kwap/rust^1
fn main () {
  -- let foo = 12_i32;
  assert_eq!(foo + 12, 24);
}
` ` `
```
