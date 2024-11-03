defmodule Exercism.PrimeFactors do
  @moduledoc """
  Compute the prime factors of a given natural number.

  A prime number is only evenly divisible by itself and 1.

  Note that 1 is not a prime number.

  Example
    What are the prime factors of 60?

    Our first divisor is 2. 2 goes into 60, leaving 30.
    2 goes into 30, leaving 15.
    2 doesn't go cleanly into 15. So let's move on to our next divisor, 3.
    3 goes cleanly into 15, leaving 5.
    3 does not go cleanly into 5. The next possible factor is 4.
    4 does not go cleanly into 5. The next possible factor is 5.
    5 does go cleanly into 5.
    We're left only with 1, so now, we're done.
    Our successful divisors in that computation represent the list of prime factors of 60: 2, 2, 3, and 5.

  You can check this yourself:

    2 * 2 * 3 * 5
    = 4 * 15
    = 60
    Success!
  """

  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: factor(number, 2, []) |> Enum.reverse

  defp factor(1, _, acc), do: acc

  defp factor(number, divisor, acc) when divisor * divisor > number, do: [number | acc]

  defp factor(number, divisor, acc) when rem(number, divisor) == 0, do:
    factor(div(number, divisor), divisor, [divisor | acc])

  defp factor(number, divisor, acc), do: factor(number, divisor + 1, acc)
end
