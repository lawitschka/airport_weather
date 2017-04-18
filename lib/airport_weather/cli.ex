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
    icao
    |> AirportWeather.WeatherData.fetch
    |> decode_response
    |> print_weather_data
  end

  defp decode_response({ :ok, observation }) do
    observation
  end

  defp decode_response({ :error, _ }) do
    IO.puts "Error fetching from NOAA"
    System.halt(2)
  end

  defp print_weather_data(%{ location: location, observation_time: observation_time, weather: weather, temperature: temperature, wind: wind }) do
    IO.puts """
    Current weather at #{location}
    ------------------------------

    Last Update: #{observation_time}
    Weather:     #{weather}
    Temperature: #{temperature}
    Wind:        #{wind}
    """
  end
end
