defmodule AirportWeather.CLI do
  @moduledoc """
  Handle the command line parsing and dispatch various functions for retrieval
  and display of weather information.
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a ICAO airport code.

  Return a string of `"icao"`, `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases:  [h: :help])

    case parse do
      { [help: true], _, _ }
        -> :help

      { _, [icao], _ }
        -> to_string(icao)

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    Usage: airport-weather <ICAO Code>
    """

    System.halt(0)
  end

  def process(icao) do
    IO.puts "Requested weather at location #{icao}"

    System.halt(0)
  end
end
