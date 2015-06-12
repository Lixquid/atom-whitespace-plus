<h1 align="center">Whitespace Plus</h1>

<p align="center">A collection of whitespace related utilities for Atom.</p>

## Features

- Commands for converting between indentation styles (hard / soft tabs, length)

## Commands

### `convert-tabs-to-x-spaces`
### `convert-x-spaces-to-tabs`

Converts a specific number of spaces into tabs, and vice versa.

Example:
```
func = ( argument ) ->
  code()
  code( more )
```
`whitespace-plus:convert-2-spaces-to-tabs`
```
func = ( argument ) ->
	code()
	code( more )
```

### `smart-convert`

Smart convert will automagically detect what indentation style the current text
document is using, and convert it to your preferred indentation style. Magic!
:sparkles:

## Configuration Options

### Change Indent Style On Convert

With this option enabled, running a conversion command will also change the
editor's current indentation style, as well as converting the text.
