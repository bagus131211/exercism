defmodule Exercism.Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b), do:
    (cond do
      equal(a, b) -> :equal
      super_list(a, b) -> :superlist
      sub_list(a, b) -> :sublist
      true -> :unequal
    end)

  defp sub_list([], _), do: true

  defp sub_list(a, b), do: b |> Stream.chunk_every(length(a), 1, :discard) |> Enum.any?(& &1 === a)

  defp super_list(_, []), do: true

  defp super_list(a, b), do: a |> Stream.chunk_every(length(b), 1, :discard) |> Enum.any?(& &1 === b)

  defp equal(a, b), do: a === b
end
