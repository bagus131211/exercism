defmodule Exercism.ListOps do
  @moduledoc """
  Please don't use any external modules (especially List or Enum) in your
  implementation. The point of this exercise is to create these basic
  functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  for adding numbers), but please do not use Kernel functions for Lists like
  `++`, `--`, `hd`, `tl`, `in`, and `length`.
  """

  @doc """
  length (given a list, return the total number of items within it)

    Example:

      iex(16)> Exercism.ListOps.count [1,2,3,4,5,6]
      6

  """
  @spec count(list) :: non_neg_integer
  def count([]), do: 0

  def count([_ | tail]), do: 1 + count(tail)

  @doc """
  reverse (given a list, return a list with all the original items, but in reversed order)

    Example:

      iex(15)> Exercism.ListOps.reverse [1,2,3,4,5,6]
      [6, 5, 4, 3, 2, 1]

  """
  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])

  defp reverse([], acc), do: acc

  defp reverse([head | tail], acc), do: reverse(tail, [head | acc])

  @doc """
  map (given a function and a list, return the list of the results of applying function(item) on all items)

    Example:

      iex(14)> Exercism.ListOps.map [1,2,3,4,5,6], fn x -> x |> to_string end
      ["1", "2", "3", "4", "5", "6"]

  """
  @spec map(list, (any -> any)) :: list
  def map(l, f), do: map(l, f, [])

  defp map([], _f, acc), do: acc |> reverse

  defp map([head | tail], f, acc), do: map(tail, f, [f.(head) | acc])

  @doc """
  filter (given a predicate and a list, return the list of all items for which predicate(item) is True)

    Example:

      iex(10)> Exercism.ListOps.filter [1,2,3,4,5,6], fn l -> rem(l, 2) !== 0 end
      [1, 3, 5]

  """
  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: filter(l, f, [])

  defp filter([], _, acc), do: acc |> reverse

  defp filter([head | tail], f, acc), do: (if f.(head), do: filter(tail, f, [head | acc]), else: filter(tail, f, acc))

  @type acc :: any
  @doc """
  foldl (given a function, a list, and initial accumulator, fold (reduce) each item into the accumulator from the left)

    Example:

      iex(8)> Exercism.ListOps.foldl [1,2,3,4,5], 10, fn l, acc -> l * acc  end
      1200

  """
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _), do: acc

  def foldl([head | tail], acc, f), do: foldl(tail, f.(head, acc), f)

  @doc """
  foldr (given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the right)

    Example:

      iex(5)> Exercism.ListOps.foldr [1,2,3,4,5], 2, fn l, acc -> l * acc end
      240

  """
  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, _), do: acc

  def foldr([head | tail], acc, f), do: f.(head, foldr(tail, acc, f))

  @doc """
  append (given two lists, add all items in the second list to the end of the first list)

    Example:

      iex(4)> Exercism.ListOps.append [1,2,3], [4,5]
      [1, 2, 3, 4, 5]

  """
  @spec append(list, list) :: list
  def append(a, []), do: a

  def append([], b), do: b

  def append([head | tail], b), do: [head | append(tail, b)]

  @doc """
  concatenate (given a series of lists, combine all items in all lists into one flattened list)

    Example:

      iex(1)> Exercism.ListOps.concat [[1,2],[3],[4,5]]
      [1, 2, 3, 4, 5]

  """
  @spec concat([[any]]) :: [any]
  def concat([]), do: []

  def concat([head | tail]), do: append(head, concat(tail))
end
