defmodule Exercism.SecretHandshake do
  @moduledoc """
  Your task is to convert a number between 1 and 31 to a sequence of actions in the secret handshake.

  The sequence of actions is chosen by looking at the rightmost five digits of the number once it's been converted to binary. Start at the right-most digit and move left.

  The actions for each number place are:

  00001 = wink
  00010 = double blink
  00100 = close your eyes
  01000 = jump
  10000 = Reverse the order of the operations in the secret handshake.
  Let's use the number 9 as an example:

  9 in binary is 1001.
  The digit that is farthest to the right is 1, so the first action is wink.
  Going left, the next digit is 0, so there is no double-blink.
  Going left again, the next digit is 0, so you leave your eyes open.
  Going left again, the next digit is 1, so you jump.
  That was the last digit, so the final code is:

  wink, jump
  Given the number 26, which is 11010 in binary, we get the following actions:

  double blink
  jump
  reverse actions
  The secret handshake for 26 is therefore:

  jump, double blink
  """
  @action %{
    1 => "wink",
    2 => "double blink",
    4 => "close your eyes",
    8 => "jump"
  }
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code), do:
   @action
   |> Enum.filter(&filter(&1, code))
   |> Enum.map(&map/1)
   |> (& if Bitwise.band(code, 16) == 16, do: &1 |> Enum.reverse, else: &1).()

  defp filter({bit, _action}, code), do: Bitwise.band(code, bit) == bit

  defp map({_bit, action}), do: action
end
