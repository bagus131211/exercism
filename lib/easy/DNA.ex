defmodule Exercism.DNA do

  @nucleotide %{
    ?A => 1,
    ?C => 2,
    ?G => 4,
    ?T => 8,
    ?\s => 0
  }

  @spec encode_nucleotide(char()) :: non_neg_integer()
  def encode_nucleotide(code_point), do: @nucleotide |> Map.get(code_point, 0)

  def decode_nucleotide(encoded_code), do:
  @nucleotide |> Enum.find(&match?({_, ^encoded_code}, &1)) |> elem(0)

  # def decode_nucleotide(encoded_code), do: encoded_code |> decode_nucleotide(Map.to_list(@nucleotide), ?\s)

  # defp decode_nucleotide(_, [], default), do: default

  # defp decode_nucleotide(encoded_code, [{char, code} | _tail], _) when code === encoded_code, do: char

  # defp decode_nucleotide(encoded_code, [_ | tail], default), do: encoded_code |> decode_nucleotide(tail, default)

  @spec encode(charlist()) :: bitstring()
  def encode(dna) when is_list(dna), do: do_encode(dna, <<>>)

  defp do_encode([], acc), do: acc

  defp do_encode([head | tail], acc), do:
   head |> encode_nucleotide |> (&do_encode(tail, <<acc::bitstring, &1::4>>)).()

  @spec decode(bitstring()) :: charlist()
  def decode(dna) when is_bitstring(dna), do: decode(dna, [])

  defp decode(<<>>, acc), do: acc |> reverse

  defp decode(bitstring, acc), do: bitstring |> describe_bitstring |> decode_function(acc)

  defp describe_bitstring(<<head::4, tail::bitstring>>), do: {head, tail}

  defp decode_function({head, tail}, acc), do: tail |> decode([head |> decode_nucleotide | acc])

  defp reverse(list, acc \\ [])

  defp reverse([], acc), do: acc

  defp reverse([head | tail], acc), do: reverse(tail, [head | acc])
end
