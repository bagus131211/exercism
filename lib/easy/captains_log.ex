defmodule Exercism.CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  @spec random_planet_class :: String.t()
  def random_planet_class, do: @planetary_classes |> Enum.random

  @spec random_ship_registry_number :: <<_::32, _::_*8>>
  def random_ship_registry_number, do: "NCC-#{Enum.random(1000..9999)}"

  @spec random_stardate :: float()
  def random_stardate, do: 41_000.0 + :rand.uniform * (42_000.0 - 41_000.0)

  @spec format_stardate(float()) :: String.t()
  def format_stardate(stardate), do: stardate |> (&:io_lib.format("~.1f", [&1])).() |> to_string
end
