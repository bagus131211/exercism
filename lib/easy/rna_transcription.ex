defmodule Exercism.RnaTranscription do
  @moduledoc """
  Your task is determine the RNA complement of a given DNA sequence.

  Both DNA and RNA strands are a sequence of nucleotides.

  The four nucleotides found in DNA are adenine (A), cytosine (C), guanine (G) and thymine (T).

  The four nucleotides found in RNA are adenine (A), cytosine (C), guanine (G) and uracil (U).

  Given a DNA strand, its transcribed RNA strand is formed by replacing each nucleotide with its complement:

  G -> C
  C -> G
  T -> A
  A -> U
  Note
  If you want to look at how the inputs and outputs are structured, take a look at the examples in the test suite.
  """

  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

    iex> RnaTranscription.to_rna(~c"ACTG")
    ~c"UGAC"
  """
  @dna_to_rna %{
    ?A => ?U,
    ?T => ?A,
    ?C => ?G,
    ?G => ?C
  }
  @spec to_rna([char]) :: [char]
  def to_rna(dna), do: dna |> Enum.map(& @dna_to_rna[&1])
end
