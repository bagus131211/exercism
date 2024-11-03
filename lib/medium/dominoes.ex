defmodule Exercism.Dominoes do
  @moduledoc """
  Make a chain of dominoes.

  Compute a way to order a given set of dominoes in such a way that they form a correct domino chain
  (the dots on one half of a stone match the dots on the neighboring half of an adjacent stone) and that dots on the halves
  of the stones which don't have a neighbor (the first and last stone) match each other.

  For example given the stones [2|1], [2|3] and [1|3] you should compute something like
    [1|2] [2|3] [3|1] or [3|2] [2|1] [1|3] or [1|3] [3|2] [2|1] etc, where the first and last numbers are the same.

  For stones [1|2], [4|1] and [2|3] the resulting chain is not valid:
    [4|1] [1|2] [2|3]'s first and last numbers are not the same. 4 != 3

  Some test cases may use duplicate stones in a chain solution, assume that multiple Domino sets are being used.
  """

  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true
  def chain?([{a,b}]), do:  a==b
  def chain?(dominoes) do
    degree_count = count_degrees(dominoes)

    # Check if all degrees are even
    if Enum.any?(degree_count, fn {_num, count} -> rem(count, 2) != 0 end) do
       false
    else

      # Use union-find to check connectedness
      union_find = Enum.reduce(dominoes, %{}, fn {a, b}, acc ->
        union(acc, a, b)
      end)


      # Get a representative for the first number that appears in the dominoes
      first_number = hd(dominoes) |> elem(0)

      # Check if all numbers with edges belong to the same set
      # Ensure that isolated nodes (those not in the union-find) are not connected
      has_edges = Enum.any?(degree_count, fn {_num, count} -> count > 0 end)
      all_connected =
        Enum.all?(degree_count, fn {num, count} ->
          (count > 0 && find(union_find, num) == find(union_find, first_number)) || count == 0
        end)
      has_edges && all_connected
    end
  end

  defp count_degrees(dominoes) do
    dominoes
    |> Enum.flat_map(fn {a, b} -> [{a, 1}, {b, 1}] end)
    |> Enum.reduce(%{}, fn {num, _}, acc -> Map.update(acc, num, 1, &(&1 + 1))
    end)
  end

  # Union-Find Implementation
  defp union(acc, a, b) do
    root_a = find(acc, a)
    root_b = find(acc, b)

    if root_a != root_b do
      Map.put(acc, root_a, root_b)
    else
      acc
    end
  end

  defp find(acc, num) do
    case Map.get(acc, num, num) do
      parent when parent == num -> parent
      parent -> find(acc, parent)
    end
  end
end
