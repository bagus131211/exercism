defmodule Exercism.CryptoSquare do
  @moduledoc """
  Implement the classic method for composing secret messages called a square code.

  Given an English text, output the encoded version of that text.

  First, the input is normalized: the spaces and punctuation are removed from the English text and the message is down-cased.

  Then, the normalized characters are broken into rows.
  These rows can be regarded as forming a rectangle when printed with intervening newlines.

  For example, the sentence

    "If man was meant to stay on the ground, god would have given us roots."
  is normalized to:

    "ifmanwasmeanttostayonthegroundgodwouldhavegivenusroots"
  The plaintext should be organized into a rectangle as square as possible.
  The size of the rectangle should be decided by the length of the message.

  If c is the number of columns and r is the number of rows, then for the rectangle r x c find the smallest possible integer c such that:

    r * c >= length of message,
    and c >= r,
    and c - r <= 1.
  Our normalized text is 54 characters long, dictating a rectangle with c = 8 and r = 7:

    "ifmanwas"
    "meanttos"
    "tayonthe"
    "groundgo"
    "dwouldha"
    "vegivenu"
    "sroots  "
  The coded message is obtained by reading down the columns going left to right.

  The message above is coded as:

    "imtgdvsfearwermayoogoanouuiontnnlvtwttddesaohghnsseoau"
  Output the encoded text in chunks that fill perfect rectangles (r X c), with c chunks of r length, separated by spaces.
  For phrases that are n characters short of the perfect rectangle, pad each of the last n chunks with a single trailing space.

    "imtgdvs fearwer mayoogo anouuio ntnnlvt wttddes aohghn  sseoau "
  Notice that were we to stack these, we could visually decode the ciphertext back in to the original message:

    "imtgdvs"
    "fearwer"
    "mayoogo"
    "anouuio"
    "ntnnlvt"
    "wttddes"
    "aohghn "
    "sseoau "
  """

  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(<<>>), do: <<>>

  def encode(str) do
    normalize = str |> String.downcase |> String.replace(~r/[^a-z0-9]/, "")
    if normalize == "" do
      ""
    else
      column = normalize |> String.length |> then(&Float.ceil(:math.sqrt(&1))) |> round
      normalize
      |> String.graphemes
      |> Stream.chunk_every(column)
      |> Stream.map(&String.pad_trailing(&1 |> to_string, column))
      |> Stream.map(&String.graphemes/1)
      |> Stream.zip
      |> Enum.map_join(" ", &Tuple.to_list(&1) |> Enum.join)
    end
  end
end
