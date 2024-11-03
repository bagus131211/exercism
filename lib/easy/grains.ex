defmodule Exercism.Grains do
  @moduledoc """
  Calculate the number of grains of wheat on a chessboard given that the number on each square doubles.

  There once was a wise servant who saved the life of a prince. The king promised to pay whatever the servant could dream up. Knowing that the king loved chess, the servant told the king he would like to have grains of wheat. One grain on the first square of a chess board, with the number of grains doubling on each successive square.

  There are 64 squares on a chessboard (where square 1 has one grain, square 2 has two grains, and so on).

  Write code that shows:

  how many grains were on a given square, and
  the total number of grains on the chessboard
  """

  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer()) :: {:ok, pos_integer()} | {:error, String.t()}
  def square(number) when number > 64 or number < 1, do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  def square(number), do: {:ok, Integer.pow(2, number - 1)}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer()}
  def total, do: 1..64 |> Stream.map(&square/1) |> Enum.reduce(0, &sum/2) |> then(&{:ok, &1})

  defp sum({:ok, value}, acc), do: acc + value
end
