defmodule Exercism.RunLengthEncoder do
  @moduledoc """
  Implement run-length encoding and decoding.

  Run-length encoding (RLE) is a simple form of data compression, where runs (consecutive data elements) are replaced by just one data value and count.

  For example we can represent the original 53 characters with only 13.

  "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB"  ->  "12WB12W3B24WB"
  RLE allows the original data to be perfectly reconstructed from the compressed data, which makes it a lossless data compression.

  "AABCCCDEEEE"  ->  "2AB3CD4E"  ->  "AABCCCDEEEE"
  For simplicity, you can assume that the unencoded string will only contain the letters A through Z (either lower or upper case) and whitespace. This way data to be encoded will never contain any numbers and numbers inside data to be decoded always represent the count for the following character.
  """

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string), do:
    string
    |> String.graphemes
    |> Enum.chunk_by(& &1)
    |> Enum.map_join(& "#{if &1 |> length > 1, do: &1 |> length}#{&1 |> hd}")

  @spec decode(String.t()) :: String.t()
  def decode(string), do:
    string
    |> String.split(~r/(\d+)([A-Za-z])|([A-Za-z])/, trim: true, include_captures: true)
    |> Enum.chunk_every(1)
    |> Enum.map_join(&process_chunk/1)

  defp process_chunk(chunk) do
    {count, char} = chunk |> to_string |> String.split_at(-1)
    String.duplicate(char, guarded_cast(count))
  end

  defp guarded_cast(count) when count in ["", nil], do: 1

  defp guarded_cast(count), do: String.to_integer(count)
end
