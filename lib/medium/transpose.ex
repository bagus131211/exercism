defmodule Exercism.Transpose do
  @moduledoc """
  Transpose the text
  """

  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"

    iex(27)> Exercism.Transpose.transpose "ABC\nDE"
    "AD\nBE\nC"
    iex(28)> Exercism.Transpose.transpose "AB\nDEF"
    "AD\nBE\n F"
    iex(29)> Exercism.Transpose.transpose "ABC\nDEF"
    "AD\nBE\nCF"
    iex(245)> Exercism.Transpose.transpose "The longest line.\n" <> "A long line.\n" <> "A longer line.\n" <> "A line."
    "TAAA\nh   \nelll\n ooi\nlnnn\nogge\nn e.\nglr\nei \nsnl\ntei\n .n\nl e\ni .\nn\ne\n."
    iex(290)> Exercism.Transpose.transpose "T\n" <> "EE\n" <> "AAA\n" <> "SSSS\n" <> "EEEEE\n" <> "RRRRRR"
    "TEASER\n EASER\n  ASER\n   SER\n    ER\n     R"

  """
  @spec transpose(String.t()) :: String.t()
  def transpose(input), do:
    input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> List.foldr([], &zipped/2)
      |> Enum.join("\n")

  defp zipped([], []), do: []

  defp zipped([], [head | tail]), do: [" " <> head | zipped([], tail)]

  defp zipped([head | rest], []), do: [head | zipped(rest, [])]

  defp zipped([head1 | rest1], [head2 | rest2]), do: [head1 <> head2 | zipped(rest1, rest2)]
end
