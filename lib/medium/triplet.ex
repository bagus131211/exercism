defmodule Exercism.Triplet do
  @moduledoc """
  A Pythagorean triplet is a set of three natural numbers, {a, b, c}, for which,

    a² + b² = c²
  and such that,

    a < b < c
  For example,

    3² + 4² = 5².
  Given an input integer N, find all Pythagorean triplets for which a + b + c = N.

  For example, with N = 1000, there is exactly one Pythagorean triplet for which a + b + c = 1000: {200, 375, 425}.

  """

  @doc """
  Calculates sum of a given triplet of integers.

    Example:

      iex(13)> Exercism.Triplet.sum [3,4,5]
      12

  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet), do: triplet |> Enum.sum

  @doc """
  Calculates product of a given triplet of integers.

    Example:

      iex(14)> Exercism.Triplet.product [3,4,5]
      60

  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet), do: triplet |> Enum.product

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?

    Example:

      iex(15)> Exercism.Triplet.pythagorean? [3,4,5]
      true

  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]), do: a * a + b * b == c * c

  @doc """
  Generates a list of pythagorean triplets whose values add up to a given sum.

    Example:

      iex(16)> Exercism.Triplet.generate 90
      [[9, 40, 41], [15, 36, 39]]
      iex(18)> Exercism.Triplet.generate 12
      [[3, 4, 5]]
      iex(34)> Exercism.Triplet.generate 30000
      [[1200, 14375, 14425], [1875, 14000, 14125], [5000, 12000, 13000], [6000, 11250, 12750], [7500, 10000, 12500]]

  """
  @spec generate(non_neg_integer) :: [list(non_neg_integer)]
  def generate(sum) when sum > 2, do:
    (for a <- 1..(sum |> div(3)),
         b <- (a + 1)..(sum - a |> div(2)),
         c = sum - a - b,
         pythagorean?([a, b, c]), do: [a, b, c])

  def generate_unrefactored(sum), do:
    (for a <- 1..(sum - 2),
         b <- (a + 1)..(sum - a - 1),
         c = sum - a - b,
         pythagorean?([a, b, c]), do: [a, b, c]
    )
end
