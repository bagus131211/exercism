defmodule Exercism.RomanNumerals do
  @moduledoc """
  Your task is to convert a number from Arabic numerals to Roman numerals.

  For this exercise, we are only concerned about traditional Roman numerals, in which the largest number is MMMCMXCIX (or 3,999).
  """
  @roman [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number), do: convert(number, <<>>)

  defp convert(0, acc), do: acc

  defp convert(number, acc), do:
    @roman
    |> Enum.find(& number >= elem(&1, 0))
    |> (case do: ({value, roman} -> convert(number - value, acc <> roman)))
end
