defmodule Exercism.Matrix do
  @moduledoc """
  Given a string representing a matrix of numbers, return the rows and columns of that matrix.

  So given a string with embedded newlines like:

    9 8 7
    5 3 2
    6 6 7
  representing this matrix:

        1  2  3
      |---------
    1 | 9  8  7
    2 | 5  3  2
    3 | 6  6  7
  your code should be able to spit out:

    A list of the rows, reading each row left-to-right while moving top-to-bottom across the rows,
    A list of the columns, reading each column top-to-bottom while moving from left-to-right.
  The rows for our example matrix:

    9, 8, 7
    5, 3, 2
    6, 6, 7
  And its columns:

    9, 5, 6
    8, 3, 6
    7, 2, 7
  """
  alias Exercism.Matrix
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
    def from_string(input), do:
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
      |> then(& %Matrix{matrix: &1})

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix), do:
    matrix.matrix
    |> Enum.map(&Enum.join(Enum.map(&1, fn m -> Integer.to_string(m) end), " "))
    |> Enum.join("\n")

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix), do: matrix.matrix

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index), do: matrix.matrix |> get_in([Access.at!(index)])

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix), do: (
    for i <- 0..(matrix.matrix |> hd |> length |> Kernel.-(1)), do:
      matrix.matrix |> Enum.map(&Enum.at(&1, i))
  )

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index), do: matrix.matrix |> Enum.map(&Enum.at(&1, index))
end
