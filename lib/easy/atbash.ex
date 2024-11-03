defmodule Exercism.Atbash do
  @moduledoc """
  Create an implementation of the atbash cipher, an ancient encryption system created in the Middle East.

  The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the alphabet such that the resulting alphabet is backwards. The first letter is replaced with the last letter, the second with the second-last, and so on.

  An Atbash cipher for the Latin alphabet would be as follows:

  Plain:  abcdefghijklmnopqrstuvwxyz
  Cipher: zyxwvutsrqponmlkjihgfedcba
  It is a very weak cipher because it only has one possible key, and it is a simple mono-alphabetic substitution cipher. However, this may not have been an issue in the cipher's time.

  Ciphertext is written out in groups of fixed length, the traditional group size being 5 letters, leaving numbers unchanged, and punctuation is excluded. This is to make it harder to guess things based on word boundaries. All text will be encoded as lowercase letters.

  Examples
  Encoding test gives gvhg
  Encoding x123 yes gives c123b vh
  Decoding gvhg gives test
  Decoding gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt gives thequickbrownfoxjumpsoverthelazydog
  """

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext), do:
    plaintext
    |> String.downcase
    |> String.replace(~r/[^a-z0-9]/, "")
    |> to_charlist
    |> Enum.map(&encode_char/1)
    |> Enum.chunk_every(5)
    |> Enum.map_join(" ", &Enum.join/1)

  defp encode_char(char) when char in ?a..?z, do: atbash(char, ?a)

  defp encode_char(char), do: <<char>>

  defp atbash(char, base), do: <<25 - (char - base) + base>>

  @spec decode(String.t()) :: String.t()
  def decode(cipher), do:
   cipher
   |> String.replace(~r/[^a-z0-9]/, "")
   |> to_charlist
   |> Enum.map_join(&encode_char/1)
end
