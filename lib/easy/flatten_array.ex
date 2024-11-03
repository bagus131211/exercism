defmodule Exercism.FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1, 2, 3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """
  @spec flatten(list) :: list
  def flatten(list), do: list |> Enum.flat_map(&case/1)

  defp case(nil), do: []

  defp case(x) when is_list(x), do: x |> Enum.flat_map(&case/1)

  defp case(other), do: [other]
end
