defmodule Exercism.BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """
  @pronoun %{
    1 => "One",
    2 => "Two",
    3 => "Three",
    4 => "Four",
    5 => "Five",
    6 => "Six",
    7 => "Seven",
    8 => "Eight",
    9 => "Nine",
    10 => "Ten"
  }

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down), do:
    start_bottle..(start_bottle - take_down + 1)
    |> Enum.map(&lyrics/1)
    |> Enum.join("\n\n")

  defp lyrics(1), do:
    """
    One green bottle hanging on the wall,
    One green bottle hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be no green bottles hanging on the wall.
    """
    |> String.trim

  defp lyrics(count), do:
    """
    #{@pronoun[count]} green bottles hanging on the wall,
    #{@pronoun[count]} green bottles hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be #{String.downcase(@pronoun[count - 1])} green #{if @pronoun[count - 1] == "One", do: "bottle", else: "bottles" } hanging on the wall.
    """
    |> String.trim
end
