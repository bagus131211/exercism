defmodule Exercism.ResistorColorTrio do
  @moduledoc """
  In Resistor Color Duo you decoded the first two colors.
  For instance: orange-orange got the main value 33.
  The third color stands for how many zeros need to be added to the main value.
  The main value plus the zeros gives us a value in ohms.
  For the exercise it doesn't matter what ohms really are. For example:

    orange-orange-black would be 33 and no zeros, which becomes 33 ohms.
    orange-orange-red would be 33 and 2 zeros, which becomes 3300 ohms.
    orange-orange-orange would be 33 and 3 zeros, which becomes 33000 ohms.

  (If Math is your thing, you may want to think of the zeros as exponents of 10.
  If Math is not your thing, go with the zeros. It really is the same thing,
  just in plain English instead of Math lingo.)

  This exercise is about translating the colors into a label:

    "... ohms"

  So an input of "orange", "orange", "black" should return:

    "33 ohms"

  When we get to larger resistors, a metric prefix is used to indicate a larger magnitude of ohms,
  such as "kiloohms". That is similar to saying "2 kilometers" instead of "2000 meters",
  or "2 kilograms" for "2000 grams".

  For example, an input of "orange", "orange", "orange" should return:

    "33 kiloohms"
  """

  @colors %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }
  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label([first, second, multiplier | _]), do:
    [@colors[first], @colors[second]]
    |> Integer.undigits
    |> Kernel.*(Integer.pow(10, @colors[multiplier]))
    |> format

  def label_if_multiplier_is_many([first, second | multiplier]) do
    value = [@colors[first], @colors[second]] |> Integer.undigits
    multiplier_value = get_multiplier(multiplier)
    result = value * multiplier_value
    format(result)
  end

  defp get_multiplier([]), do: 1

  defp get_multiplier([head | tail]), do:
    Integer.pow(10, @colors[head]) * get_multiplier(tail)

  defp format(result) when result >= 1_000_000_000, do: {div(result, 1_000_000_000), :gigaohms}

  defp format(result) when result >= 1_000_000, do: {div(result, 1_000_000), :megaohms}

  defp format(result) when result >= 1_000, do: {div(result, 1_000), :kiloohms}

  defp format(result), do: {result, :ohms}
end
