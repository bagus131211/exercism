defmodule Exercism.KitchenCalculator do
  @table %{
    cup: 240,
    fluid_ounce: 30,
    teaspoon: 5,
    tablespoon: 15,
    milliliter: 1
  }

  def get_volume({_, volume}), do: volume

  def to_milliliter({unit, volume}), do: {:milliliter, volume * (@table |> Map.get(unit))}

  def from_milliliter({:milliliter, volume}, unit), do: {unit, volume / (@table |> Map.get(unit))}

  def convert(volume_pair, unit), do: volume_pair |> to_milliliter |> from_milliliter(unit)
end
