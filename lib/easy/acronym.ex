defmodule Exercism.Acronym do
  @moduledoc """
  Instructions
  Convert a phrase to its acronym.

  Techies love their TLA (Three Letter Acronyms)!

  Help generate some jargon by writing a program that converts a long name like Portable Network Graphics to its acronym (PNG).

  Punctuation is handled as follows: hyphens are word separators (like whitespace); all other punctuation can be removed from the input.

  For example:

  Input	                      Output
  As Soon As Possible	        ASAP
  Liquid-crystal display	    LCD
  Thank George It's Friday!	  TGIF
  """

  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string), do:
  string
  |> String.split(~r/[^\p{L}\p{N}']+/)
  |> Enum.map(&String.at(&1, 0))
  |> Enum.filter(&(&1 !== nil))
  |> to_string
  |> String.upcase
end
