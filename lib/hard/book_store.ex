defmodule Exercism.BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5
  @type group :: %{book => float}
  @group %{
    1 => 800 * 1,
    2 => 800 * 2 * 0.95,
    3 => 800 * 3 * 0.90,
    4 => 800 * 4 * 0.80,
    5 => 800 * 5 * 0.75
  }

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.

    ## Example:

      iex(53)> Exercism.BookStore.total [1,1,2, 2, 3,3, 4, 5]
      5120

      iex(54)> Exercism.BookStore.total [1, 2, 2]
      2320

      iex(55)> Exercism.BookStore.total [1, 2]
      1520

      iex(10)> Exercism.BookStore.total [1,1,2,3,4,4,5,5]
      5120

      iex(12)> Exercism.BookStore.total [1,1,2,2,3,4]
      4080

      iex(13)> Exercism.BookStore.total [1,1,2,2,3,3,4,4,5]
      5560

      iex(14)> Exercism.BookStore.total [1,1,2,2,3,3,4,4,5,5]
      6000

      iex(15)> Exercism.BookStore.total [1,1,2,2,3,3,4,4,5,5,1]
      6800

      iex(16)> Exercism.BookStore.total [1,1,2,2,3,3,4,4,5,5,1,2]
      7520

  """
  @spec total(basket :: [book]) :: integer
  def total([]), do: 0

  def total(basket), do: basket |> Enum.frequencies |> minimum_price |> round

  defp minimum_price(frequencies) when map_size(frequencies) == 0, do: 0

  defp minimum_price(frequencies), do:
    1..5
      |> Enum.filter(&possible?(&1, frequencies))
      |> Enum.map(fn group_size ->
        updated = group_books(frequencies, group_size)
        @group[group_size] + minimum_price(updated)
      end)
      |> Enum.min

  defp possible?(size, frequencies), do: map_size(frequencies) >= size

  defp group_books(frequencies, size), do:
    frequencies
      |> Enum.sort_by(fn {_book, count} -> -count end)
      |> Enum.map(fn {book, _count} -> book end)
      |> Enum.take(size)
      |> Enum.reduce(frequencies, fn book, acc ->
          Map.update!(acc, book, &(&1 - 1))
          |> Enum.reject(fn {_book, count} -> count == 0 end)
          |> Enum.into(%{})
    end)
end
