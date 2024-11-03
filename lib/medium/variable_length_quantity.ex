defmodule Exercism.VariableLengthQuantity do
  @moduledoc """
  Instructions
  Implement variable length quantity encoding and decoding.

  The goal of this exercise is to implement VLQ encoding/decoding.

  In short, the goal of this encoding is to encode integer values in a way that would save bytes.
  Only the first 7 bits of each byte are significant (right-justified; sort of like an ASCII byte).
  So, if you have a 32-bit value, you have to unpack it into a series of 7-bit bytes.
  Of course, you will have a variable number of bytes depending upon your integer.
  To indicate which is the last byte of the series, you leave bit #7 clear. In all of the preceding bytes, you set bit #7.

  So, if an integer is between 0-127, it can be represented as one byte. Although VLQ can deal with numbers of arbitrary sizes,
  for this exercise we will restrict ourselves to only numbers that fit in a 32-bit unsigned integer.
  Here are examples of integers as 32-bit values, and the variable length quantities that they translate to:

      NUMBER        VARIABLE QUANTITY
      00000000              00
      00000040              40
      0000007F              7F
      00000080             81 00
      00002000             C0 00
      00003FFF             FF 7F
      00004000           81 80 00
      00100000           C0 80 00
      001FFFFF           FF FF 7F
      00200000          81 80 80 00
      08000000          C0 80 80 00
      0FFFFFFF          FF FF FF 7F
  """

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes

    Example:

      iex(36)> Exercism.VariableLengthQuantity.encode [0x0]
      <<0>>

      iex(37)> Exercism.VariableLengthQuantity.encode [0x40]
      "@"

      iex(38)> Exercism.VariableLengthQuantity.encode [0x7F]
      "\d"

      iex(39)> Exercism.VariableLengthQuantity.encode [0x80]
      <<0, 194, 129>>

      iex(40)> Exercism.VariableLengthQuantity.encode [0x2000]
      <<0, 195, 128>>

  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers), do: integers |> Enum.map(&process/1) |> :erlang.list_to_binary

  defp process(0), do: [0x00]

  defp process(integer), do:
    integer
      |> into_seven_bits_chunks([])
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.map(fn {byte, index} ->
        if index == 0, do: byte, else: Bitwise.bor(byte, 0x80)
      end)
      |> Enum.reverse

  defp into_seven_bits_chunks(0, acc), do: acc

  defp into_seven_bits_chunks(integer, acc), do: into_seven_bits_chunks(Bitwise.bsr(integer, 7), [Bitwise.band(integer, 0x7F) | acc])

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers

      Example:

        iex(45)> Exercism.VariableLengthQuantity.decode "\d"
        {:ok, [127, 0]}

        iex(46)> Exercism.VariableLengthQuantity.decode <<0, 194, 129>>
        {:ok, [0, 8449]}

        iex(47)> Exercism.VariableLengthQuantity.decode "@"
        {:ok, [64, 0]}

  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: bytes |> :binary.bin_to_list |> decode_bytes(0, [])

  defp decode_bytes([], 0, acc), do: {:ok, Enum.reverse(acc)}

  defp decode_bytes([], _, _), do: {:error, "incomplete sequence"}

  defp decode_bytes([head | tail], current, acc) do
    value = Bitwise.bor(Bitwise.bsl(current, 7), Bitwise.band(head, 0x7F))
    if Bitwise.band(head, 0x80) == 0,
      do: decode_bytes(tail, 0, [value | acc]),
      else: (
          if tail == [],
            do: {:error, "incomplete sequence"},
            else: decode_bytes(tail, value, acc)
      )
  end
end
