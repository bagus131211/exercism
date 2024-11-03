defmodule Exercism.Raindrops do
  @moduledoc """
  Raindrops is a slightly more complex version of the FizzBuzz challenge, a classic interview question.
  """

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number), do:
    ~w(Pling Plang Plong)
    |> Enum.reduce("", &check(&1, &2, number))
    |> (& if &1 == <<>>, do: to_string(number), else: &1).()

  defp check(word, acc, number), do:
    (cond do
          rem(number, 3) == 0 and word == "Pling" -> acc <> word
          rem(number, 5) == 0 and word == "Plang" -> acc <> word
          rem(number, 7) == 0 and word == "Plong" -> acc <> word
          true -> acc end)
end
