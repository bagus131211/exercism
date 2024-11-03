defmodule Exercism.Anagram do
  @moduledoc """
  Instructions
  Your task is to, given a target word and a set of candidate words, to find the subset of the candidates that are anagrams of the target.

  An anagram is a rearrangement of letters to form a new word: for example "owns" is an anagram of "snow". A word is not its own anagram: for example, "stop" is not an anagram of "stop".

  The target and candidates are words of one or more ASCII alphabetic characters (A-Z and a-z). Lowercase and uppercase characters are equivalent: for example, "PoTS" is an anagram of "sTOp", but StoP is not an anagram of sTOp. The anagram set is the subset of the candidate set that are anagrams of the target (in any order). Words in the anagram set should have the same letter case as in the candidate set.

  Given the target "stone" and candidates "stone", "tones", "banana", "tons", "notes", "Seton", the anagram set is "tones", "notes", "Seton".
  """

  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates), do:
  candidates
  |> Enum.filter(&anagram?(set(base), &1) and String.length(&1) == String.length(base) and String.downcase(&1) != String.downcase(base))

  defp set(base), do: base |> String.downcase |> String.graphemes |> Enum.sort

  defp anagram?(base_set, candidate_base), do: base_set === set(candidate_base)
end
