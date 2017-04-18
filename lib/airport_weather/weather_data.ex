defmodule AirportWeather.WeatherData do
  @moduledoc """
  Fetches current weather observation data from the National Oceanic and
  Atmospheric Administration information service and returns a Elixir map.
  """

  import SweetXml

  require Logger

  @noaa_url Application.get_env(:airport_weather, :noaa_url)

  @doc """
  Given an ICAO code, returns a tuple with `:ok` as first item and a map
  containing the last observed weather data as second item. In case of an error
  the status `:error` and an error message will be returned.

  ## Example:
    iex> icao = "KJFK"
    iex> AirportWeather.WeatherData.fetch icao
    { :ok, %{station_id: "KJFK", latitude: 40.63, longitude: -73.76, ... } }
  """
  def fetch(icao_code) do
    icao_code
    |> observation_url
    |> HTTPoison.get
    |> handle_response
  end

  defp observation_url(icao_code) do
    "#{@noaa_url}//xml/current_obs/#{String.upcase icao_code}.xml"
  end

  defp handle_response({ :error, %{status_code: status, body: _} }) do
    Logger.error "Error #{status} returned"
    { :error, "Something went wrong" }
  end

  defp handle_response({ :ok, %{status_code: 200, body: body}}) do
    Logger.info "Fetched observation data"
    weather = body |> :binary.bin_to_list |> :xmerl_scan.string |> parse_xml
    { :ok, weather }
  end

  defp parse_xml({ doc, _ }) do
    doc
    |> xpath(
      ~x"/current_observation",
      location: ~x"./location/text()",
      observation_time: ~x"./observation_time/text()",
      weather: ~x"./weather/text()",
      temperature: ~x"./temperature_string/text()",
      wind: ~x"./wind_string/text()"
    )
  end
end
