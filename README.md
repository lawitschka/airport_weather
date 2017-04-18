# Airport Weather

CLI tool for fetching and displaying current weather information provided by the
National Oceanic and Atmospheric Administration.

This tool is an exercise from the "Programming Elixir" book.

## Installation

The binary is not included in source code. To try out the CLI tool, install all
dependencies and build the binary yourself:

```
$> mix deps.get
$> mix escript.build
```

## Usage

`$> ./airport-weather <ICAO Code>`

e.g. for John F. Kennedy Airport in New York

`$> ./airport-weather KJFK`
