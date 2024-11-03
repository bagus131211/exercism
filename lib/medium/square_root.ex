defmodule Exercism.SquareRoot do
  @moduledoc """
  Given a natural radicand, return its square root.

  Note that the term "radicand" refers to the number for which the root is to be determined.
  That is, it is the number under the root symbol.

  Check out the Wikipedia pages on square root and methods of computing square roots.

  Recall also that natural numbers are positive real whole numbers (i.e. 1, 2, 3 and up).

  Make sure you implement an algorithm that doesn't rely on built-in functions such as :math.sqrt/1 or Float.pow/2.
  """

  @doc """
  Calculate the integer square root of a positive integer

    Example:

      iex(29)> Exercism.SquareRoot.calculate 16
      4
      iex(30)> Exercism.SquareRoot.calculate 25
      5
      iex(31)> Exercism.SquareRoot.calculate 81
      9
      iex(32)> Exercism.SquareRoot.calculate 19
      4
      iex(33)> Exercism.SquareRoot.calculate 18
      4
      iex(34)> Exercism.SquareRoot.calculate 196
      14
      iex(35)> Exercism.SquareRoot.calculate 65025
      255

  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(0), do: 0

  def calculate(radicand), do: binary_search(1, radicand, radicand)

  defp binary_search(low, high, radicand) when low <= high do
    mid =  Bitwise.bsr(low + high, 1)
    case mid * mid do
      x when x == radicand -> mid
      x when x < radicand -> binary_search(mid + 1, high, radicand)
      _ -> binary_search(low, mid - 1, radicand)
    end
  end

  defp binary_search(_, high, _), do: high
end
