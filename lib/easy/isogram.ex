defmodule Exercism.Isogram do
  @moduledoc """
  Determine if a word or phrase is an isogram.

  An isogram (also known as a "non-pattern word") is a word or phrase without a repeating letter, however spaces and hyphens are allowed to appear multiple times.

  Examples of isograms:

  lumberjacks
  background
  downstream
  six-year-old
  The word isograms, however, is not an isogram, because the s repeats.
  """

  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence), do:
   !(sentence
   |> String.downcase
   |> String.replace(~r/\s+|-/, "")
   |> String.graphemes
   |> Enum.frequencies
   |> Enum.any?(&check/1))

  defp check({_, count}), do: count > 1
end
