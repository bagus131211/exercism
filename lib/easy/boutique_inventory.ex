defmodule Exercism.BoutiqueInventory do

  @spec sort_by_price([map()]) :: [map()]
  def sort_by_price(inventory), do: inventory |> Enum.sort_by(& &1.price)

  @spec with_missing_price([map()]) :: [map()]
  def with_missing_price(inventory), do: inventory |> Enum.filter(& is_nil(&1.price))

  @spec update_names([map()], String.t(), String.t()) :: [map()]
  def update_names(inventory, old_word, new_word), do:
    inventory
    |> Enum.map(&replace(&1, old_word, new_word))

  defp replace(item, old_word, new_word), do:
    Map.update!(item, :name, &String.replace(&1, old_word, new_word))

  @spec increase_quantity(map(), non_neg_integer()) :: map()
  def increase_quantity(item, count), do:
    %{item | quantity_by_size: item.quantity_by_size
     |> Map.new(&calculate(&1, count))
    }

  defp calculate({size, quantity}, count), do: {size, quantity + count}

  @spec total_quantity_without_reduce(map()) :: non_neg_integer()
  def total_quantity_without_reduce(item), do: item.quantity_by_size |> Map.values |> Enum.sum

  @spec total_quantity(map()) :: non_neg_integer()
  def total_quantity(item), do: item.quantity_by_size |> Enum.reduce(0, &calculate_total(&2, &1))

  defp calculate_total(acc, {_, quantity}), do: acc + quantity
end
