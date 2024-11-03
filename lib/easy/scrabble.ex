defmodule Exercism.Scrabble do
  @moduledoc """
  Scrabble is a word game where players place letter tiles on a board to form words. Each letter has a value. A word's score is the sum of its letters' values.
  """
  @scrabble %{
    1 => ~w(A I U E O L N R S T),
    2 => ~w(D G),
    3 => ~w(B C M P),
    4 => ~w(F H V W Y),
    5 => ~w(K),
    8 => ~w(J X),
    10 => ~w(Q Z)
  }
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word), do:
    word
    |> String.upcase
    |> String.graphemes
    |> Enum.map(&get_score/1)
    |> Enum.sum

  defp get_score(letter), do: @scrabble |> Enum.find_value(0, &matching(&1, letter))

  defp matching({score, letters}, letter), do: letter in letters && score
end
