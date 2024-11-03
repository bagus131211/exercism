defmodule Exercism.ProteinTranslation do
  @moduledoc """
  Translate RNA sequences into proteins.

  RNA can be broken into three nucleotide sequences called codons, and then translated to a polypeptide like so:

  RNA: "AUGUUUUCU" => translates to

  Codons: "AUG", "UUU", "UCU" => which become a polypeptide with the following sequence =>

  Protein: "Methionine", "Phenylalanine", "Serine"

  There are 64 codons which in turn correspond to 20 amino acids; however, all of the codon sequences and resulting amino acids are not important in this exercise. If it works for one codon, the program should work for all of them. However, feel free to expand the list in the test suite to include them all.

  There are also three terminating codons (also known as 'STOP' codons); if any of these codons are encountered (by the ribosome), all translation ends and the protein is terminated.

  All subsequent codons after are ignored, like this:

  RNA: "AUGUUUUCUUAAAUG" =>

  Codons: "AUG", "UUU", "UCU", "UAA", "AUG" =>

  Protein: "Methionine", "Phenylalanine", "Serine"

  Note the stop codon "UAA" terminates the translation and the final methionine is not translated into the protein sequence.

  Below are the codons and resulting Amino Acids needed for the exercise.

  Codon	Protein
  AUG	Methionine
  UUU, UUC	Phenylalanine
  UUA, UUG	Leucine
  UCU, UCC, UCA, UCG	Serine
  UAU, UAC	Tyrosine
  UGU, UGC	Cysteine
  UGG	Tryptophan
  UAA, UAG, UGA	STOP
  """

  @codon %{
    Methionine: ["AUG"],
    Phenylalanine: ["UUU", "UUC"],
    Leucine: ["UUA", "UUG"],
    Serine: ["UCU", "UCC", "UCA", "UCG"],
    Tyrosine: ["UAU", "UAC"],
    Cysteine: ["UGU", "UGC"],
    Tryptophan: ["UGG"],
    STOP: ["UAA", "UAG", "UGA"]
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna) when rna !== "" do
   if invalid?(rna) do
    {:error, "invalid RNA"}
   else
    rna
    |> String.graphemes
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.join/1)
    |> Enum.reduce_while([], &acc/2)
    |> (case do: ([] -> {:ok, []}; result -> {:ok, result}))
   end
  end

  def of_rna(_), do: {:ok, []}

  defp acc(codon, acc), do: (case get_codon(codon),
    do: ("STOP" -> {:halt, acc};
        nil -> {:halt, acc};
        acid -> {:cont, acc ++ [acid]}))

  defp get_codon(codon), do: @codon |> Enum.find_value(fn {acid, codons} ->
    if codon in codons, do: to_string(acid), else: nil
  end)

  defp invalid?(rna) do
    (if String.length(rna) < 5 do
      rem(String.length(rna), 3) != 0
    else
      false
    end) or not String.match?(rna, ~r/^[AUCG]+$/)
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    case get_codon(codon) do
      nil -> {:error, "invalid codon"}
      codon -> {:ok, codon}
    end
  end
end
