defmodule Exercism.SaddlePoints do
  @moduledoc """
  Instructions
  Your task is to find the potential trees where you could build your tree house.

  The data company provides the data as grids that show the heights of the trees.
  The rows of the grid represent the east-west direction, and the columns represent the north-south direction.

  An acceptable tree will be the largest in its row, while being the smallest in its column.

  A grid might not have any good trees at all. Or it might have one, or even several.

  Here is a grid that has exactly one candidate tree.

        1  2  3  4
      |-----------
    1 | 9  8  7  8
    2 | 5  3  2  4  <--- potential tree house at row 2, column 1, for tree with height 5
    3 | 6  6  7  1

    Row 2 has values 5, 3, 2, and 4. The largest value is 5.
    Column 1 has values 9, 5, and 6. The smallest value is 5.
    So the point at [2, 1] (row: 2, column: 1) is a great spot for a tree house.

  """

  @doc """
  Parses a string representation of a matrix
  to a list of rows

    Example:

      iex(112)> Exercism.SaddlePoints.rows "1 4 9\n16 25 36"
      [[1, 4, 9], [16, 25, 36]]

  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str), do: str |> String.split("\n", trim: true) |> Enum.map(fn r -> r |> String.split |> Enum.map(&String.to_integer/1) end)

  @doc """
  Parses a string representation of a matrix
  to a list of columns

    Example:

      iex(114)> Exercism.SaddlePoints.columns "1 2 3\n4 5 6\n7 8 9\n8 7 6"
      [[1, 4, 7, 8], [2, 5, 8, 7], [3, 6, 9, 6]]

  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str), do: str |> rows |> Enum.zip |> Enum.map(&Tuple.to_list/1)

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix

    Example:

      iex(125)> Exercism.SaddlePoints.saddle_points "6 7 7\n5 5 5\n7 5 6"
      [{2, 1}, {2, 2}, {2, 3}]
      iex(127)> Exercism.SaddlePoints.saddle_points "9 8 1\n5 3 2\n6 6 7"
      [{2, 1}]
      iex(128)> Exercism.SaddlePoints.saddle_points "1 2 3\n3 1 2\n2 3 1"
      []
      iex(129)> Exercism.SaddlePoints.saddle_points "4 5 4\n3 5 5\n1 5 4"
      [{1, 2}, {2, 2}, {3, 2}]

  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    matrix = str |> rows
    max_row = matrix
      |> Enum.with_index
      |> Enum.flat_map(fn {row, row_index} ->
          Enum.with_index(row)
            |> Enum.filter(fn {val, _} -> val == Enum.max(row) end)
            |> Enum.map(fn {val, col_index} -> {val, {row_index + 1, col_index + 1}} end)
          end)
    min_col = str
      |> columns
      |> Enum.with_index
      |> Enum.flat_map(fn {col, col_index} ->
          Enum.with_index(col)
            |> Enum.filter(fn {val, _} -> val == Enum.min(col) end)
            |> Enum.map(fn {val, row_index} -> {val, {row_index + 1, col_index + 1}} end)
          end)

    Enum.filter(max_row, fn {val, {row_idx, col_idx}} ->
      Enum.any?(min_col, fn {col_val, {r_idx, c_idx}} ->
        val == col_val and row_idx == r_idx and col_idx == c_idx
      end)
    end)
    |> Enum.map(fn {_val, index} -> index end)
  end
end
