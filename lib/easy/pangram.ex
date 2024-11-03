defmodule Exercism.Pangram do
  @moduledoc """
  Your task is to figure out if a sentence is a pangram.

  A pangram is a sentence using every letter of the alphabet at least once. It is case insensitive, so it doesn't matter if a letter is lower-case (e.g. k) or upper-case (e.g. K).

  For this exercise, a sentence is a pangram if it contains each of the 26 letters in the English alphabet.
  """

  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence), do:
   sentence
   |> String.downcase
   |> String.graphemes
   |> Enum.filter(& &1 =~ ~r/[a-z]/)
   |> Enum.uniq
   |> Enum.count == 26
end
