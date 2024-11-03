defmodule Exercism.RailFenceCipher do
  @moduledoc """
  Instructions
  Implement encoding and decoding for the rail fence cipher.

  The Rail Fence cipher is a form of transposition cipher that gets its name from the way in which it's encoded.
  It was already used by the ancient Greeks.

  In the Rail Fence cipher, the message is written downwards on successive "rails" of an imaginary fence,
  then moving up when we get to the bottom (like a zig-zag). Finally the message is then read off in rows.

  For example, using three "rails" and the message "WE ARE DISCOVERED FLEE AT ONCE", the cipherer writes out:

      W . . . E . . . C . . . R . . . L . . . T . . . E
      . E . R . D . S . O . E . E . F . E . A . O . C .
      . . A . . . I . . . V . . . D . . . E . . . N . .
  Then reads off:

    WECRLTEERDSOEEFEAOCAIVDEN
  To decrypt a message you take the zig-zag shape and fill the ciphertext along the rows.

      ? . . . ? . . . ? . . . ? . . . ? . . . ? . . . ?
      . ? . ? . ? . ? . ? . ? . ? . ? . ? . ? . ? . ? .
      . . ? . . . ? . . . ? . . . ? . . . ? . . . ? . .
  The first row has seven spots that can be filled with "WECRLTE".

      W . . . E . . . C . . . R . . . L . . . T . . . E
      . ? . ? . ? . ? . ? . ? . ? . ? . ? . ? . ? . ? .
      . . ? . . . ? . . . ? . . . ? . . . ? . . . ? . .
  Now the 2nd row takes "ERDSOEEFEAOC".

      W . . . E . . . C . . . R . . . L . . . T . . . E
      . E . R . D . S . O . E . E . F . E . A . O . C .
      . . ? . . . ? . . . ? . . . ? . . . ? . . . ? . .
  Leaving "AIVDEN" for the last row.

      W . . . E . . . C . . . R . . . L . . . T . . . E
      . E . R . D . S . O . E . E . F . E . A . O . C .
      . . A . . . I . . . V . . . D . . . E . . . N . .
  If you now read along the zig-zag shape you can read the original message.
  """

  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext

    Example:

      iex(5)> Exercism.RailFenceCipher.encode "WEAREDISCOVEREDFLEEATONCE", 3
      "WECRLTEERDSOEEFEAOCAIVDEN"

      iex(9)> Exercism.RailFenceCipher.encode "XOXOXOXOXOXOXOXOXO", 2
      "XXXXXXXXXOOOOOOOOO"

      iex(10)> Exercism.RailFenceCipher.encode "EXERCISES", 4
      "ESXIEECSR"

      iex(15)> Exercism.RailFenceCipher.encode "The quick brown fox jumps over the lazy dog.", 4
      "Tioxs aghucrwo p rtlzo.eqkbnfjmoeh yd   uve "

  """

  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str

  def encode(str, rails), do:
    str |> String.graphemes |> build_rails(rails) |> Enum.map_join(&Enum.map(&1, fn {_, char} -> char end))

  defp build_rails(letter, rails), do: 0..(rails - 1) |> Enum.map(fn _ -> [] end) |> letter_on_rails(letter, 0, 1)

  defp letter_on_rails(rails, [], _rail_index, _direction), do: rails

  defp letter_on_rails(rails, [head | tail], rail_index, direction) do
    updated = List.update_at(rails, rail_index, & &1 ++ [{nil, head}])
    new_direction = if(rail_index == 0, do: 1, else: if(rail_index == length(rails) - 1, do: -1, else: direction))
    new_index = rail_index + new_direction

    letter_on_rails(updated, tail, new_index, new_direction)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext

    Example:

      iex(62)> Exercism.RailFenceCipher.decode "TEITELHDVLSNHDTISEIIEA", 3
      "THEDEVILISINTHEDETAILS"

      iex(63)> Exercism.RailFenceCipher.decode "EIEXMSMESAORIWSCE", 5
      "EXERCISMISAWESOME"

      iex(64)> Exercism.RailFenceCipher.decode "Tioxs aghucrwo p rtlzo.eqkbnfjmoeh yd   uve ", 4
      "The quick brown fox jumps over the lazy dog."

  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str

  def decode(str, rails) do
    poisiton = {str |> String.length, rails} |> build_rails_for_decode
    str
      |> String.graphemes
      |> Enum.zip(poisiton)
      |> Enum.reduce(poisiton
      |> Enum.map(fn _ -> nil end), fn {char, position}, acc ->
            List.replace_at(acc, position, char)
         end)
      |> Enum.join
  end

  defp build_rails_for_decode({length, rails}), do:
    0..(rails - 1)
      |> Enum.map(fn _ -> [] end)
      |> letter_on_rails(0..(length - 1) |> Enum.to_list, 0, 1)
      |> Enum.flat_map(& &1)
      |> Enum.map(&elem(&1, 1))
end
