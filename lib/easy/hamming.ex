defmodule Exercism.Hamming do
  @moduledoc """
  Calculate the Hamming distance between two DNA strands.

  Your body is made up of cells that contain DNA. Those cells regularly wear out and need replacing, which they achieve by dividing into daughter cells. In fact, the average human body experiences about 10 quadrillion cell divisions in a lifetime!

  When cells divide, their DNA replicates too. Sometimes during this process mistakes happen and single pieces of DNA get encoded with the incorrect information. If we compare two strands of DNA and count the differences between them we can see how many mistakes occurred. This is known as the "Hamming distance".

  We read DNA using the letters C, A, G and T. Two strands might look like this:

  GAGCCTACTAACGGGAT
  CATCGTAATGACGGCCT
  ^ ^ ^  ^ ^    ^^
  They have 7 differences, and therefore the Hamming distance is 7.

  The Hamming distance is useful for lots of things in science, not just biology, so it's a nice phrase to be familiar with :)
  """

  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance(~c"AAGTCATA", ~c"TAGCGATC")
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) === length(strand2), do:
    strand1
    |> Enum.zip(strand2)
    |> Enum.count(&diff/1)
    |> (&{:ok, &1}).()

  def hamming_distance(_, _), do: {:error, "strands must be of equal length"}

  defp diff({first, second}), do: first != second
end
