defmodule Exercism.RotationalCipher do
  @moduledoc """
  Create an implementation of the rotational cipher, also sometimes called the Caesar cipher.

  The Caesar cipher is a simple shift cipher that relies on transposing all the letters in the alphabet using an integer key between 0 and 26. Using a key of 0 or 26 will always yield the same output due to modular arithmetic. The letter is shifted for as many values as the value of the key.

  The general notation for rotational ciphers is ROT + <key>. The most commonly used rotational cipher is ROT13.

  A ROT13 on the Latin alphabet would be as follows:

  Plain:  abcdefghijklmnopqrstuvwxyz
  Cipher: nopqrstuvwxyzabcdefghijklm
  It is stronger than the Atbash cipher because it has 27 possible keys, and 25 usable keys.

  Ciphertext is written out in the same formatting as the input including spaces and punctuation.

  Examples
  ROT5 omg gives trl
  ROT0 c gives c
  ROT26 Cool gives Cool
  ROT13 The quick brown fox jumps over the lazy dog. gives Gur dhvpx oebja sbk whzcf bire gur ynml qbt.
  ROT13 Gur dhvpx oebja sbk whzcf bire gur ynml qbt. gives The quick brown fox jumps over the lazy dog.
  """

  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift), do: text |> to_charlist |> Enum.map(&next_letter(&1, shift)) |> to_string

  defp next_letter(char, shift) when char in ?a..?z, do:
    {char, shift, ?a} |> calc |> (&<<&1>>).()

  defp next_letter(char, shift) when char in ?A..?Z, do:
    {char, shift, ?A} |> calc |> (&<<&1>>).()

  defp next_letter(char, _), do: <<char>>

  defp calc({char, shift, base}), do: rem(char + shift - base, 26) + base
end
