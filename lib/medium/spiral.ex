defmodule Exercism.Spiral do
  @moduledoc """
  Your task is to return a square matrix of a given size.

  The matrix should be filled with natural numbers, starting from 1 in the top-left corner, increasing in an inward,
  clockwise spiral order, like these examples:

    Examples
      Spiral matrix of size 3
        1 2 3
        8 9 4
        7 6 5
      Spiral matrix of size 4
        1  2  3 4
        12 13 14 5
        11 16 15 6
        10  9  8 7
  """

  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.

    Example:

      iex(19)> Exercism.Spiral.matrix 5
      [
        [1, 2, 3, 4, 5],
        [16, 17, 18, 19, 6],
        [15, 24, 25, 20, 7],
        [14, 23, 22, 21, 8],
        [13, 12, 11, 10, 9]
      ]

  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(dimension) when dimension <= 0, do: []

  def matrix(dimension), do:
    (for _ <- 1..dimension, do: (for _ <- 1..dimension, do: nil))
    |> fill(1, {0, 0}, dimension, :right)


  defp fill(matrix, value, {row, column}, dimension, direction), do:
    (if value > dimension * dimension,
      do: matrix,
      else: (matrix_update = matrix |> List.update_at(row, &List.update_at(&1, column, just_val(value)))
            {next_row, next_column, next_direction} = next(row, column, direction, matrix_update)
            fill(matrix_update, value + 1, {next_row, next_column}, dimension, next_direction)))

  defp just_val(value), do: fn _ -> value end

  defp next(row, column, :right, matrix), do:
    (if column + 1 < length(matrix) and {matrix, row, column + 1} |> boring_getter == nil, do: {row, column + 1, :right}, else: {row + 1, column, :down})

  defp next(row, column, :down, matrix), do:
    (if row + 1 < length(matrix) and {matrix, row + 1, column} |> boring_getter == nil, do: {row + 1, column, :down}, else: {row, column - 1, :left})

  defp next(row, column, :left, matrix), do:
    (if column - 1 >= 0 and {matrix, row, column - 1} |> boring_getter == nil, do: {row, column - 1, :left}, else: {row - 1, column, :up})

  defp next(row, column, :up, matrix), do:
    (if row - 1 >= 0 and {matrix, row - 1, column} |> boring_getter == nil, do: {row - 1, column, :up}, else: {row, column + 1, :right})

  defp boring_getter({matrix, row, column}), do: matrix |> Enum.at(row) |> Enum.at(column)
end
