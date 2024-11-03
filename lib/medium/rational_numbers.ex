defmodule Exercism.RationalNumbers do
  @moduledoc """
  A rational number is defined as the quotient of two integers a and b, called the numerator and denominator, respectively, where b != 0.

  Note
    Note that mathematically, the denominator can't be zero. However in many implementations of rational numbers,
    you will find that the denominator is allowed to be zero with behaviour similar to positive or negative infinity in
    floating point numbers. In those cases, the denominator and numerator generally still can't both be zero at once.

  The absolute value |r| of the rational number r = a/b is equal to |a|/|b|.

  The sum of two rational numbers r₁ = a₁/b₁ and r₂ = a₂/b₂ is r₁ + r₂ = a₁/b₁ + a₂/b₂ = (a₁ * b₂ + a₂ * b₁) / (b₁ * b₂).

  The difference of two rational numbers r₁ = a₁/b₁ and r₂ = a₂/b₂ is r₁ - r₂ = a₁/b₁ - a₂/b₂ = (a₁ * b₂ - a₂ * b₁) / (b₁ * b₂).

  The product (multiplication) of two rational numbers r₁ = a₁/b₁ and r₂ = a₂/b₂ is r₁ * r₂ = (a₁ * a₂) / (b₁ * b₂).

  Dividing a rational number r₁ = a₁/b₁ by another r₂ = a₂/b₂ is r₁ / r₂ = (a₁ * b₂) / (a₂ * b₁) if a₂ is not zero.

  Exponentiation of a rational number r = a/b to a non-negative integer power n is r^n = (a^n)/(b^n).

  Exponentiation of a rational number r = a/b to a negative integer power n is r^n = (b^m)/(a^m), where m = |n|.

  Exponentiation of a rational number r = a/b to a real (floating-point) number x is the quotient (a^x)/(b^x), which is a real number.

  Exponentiation of a real number x to a rational number r = a/b is x^(a/b) = root(x^a, b), where root(p, q) is the qth root of p.

  Implement the following operations:

    addition, subtraction, multiplication and division of two rational numbers,
    absolute value, exponentiation of a given rational number to an integer power, exponentiation of a given rational number to a real (floating-point) power, exponentiation of a real number to a rational number.

  Your implementation of rational numbers should always be reduced to lowest terms.
  For example, 4/4 should reduce to 1/1, 30/60 should reduce to 1/2, 12/8 should reduce to 3/2, etc.
  To reduce a rational number r = a/b, divide a and b by the greatest common divisor (gcd) of a and b.
  So, for example, gcd(12, 8) = 4, so r = 12/8 can be reduced to (12/4)/(8/4) = 3/2.
  The reduced form of a rational number should be in "standard form" (the denominator should always be a positive integer).
  If a denominator with a negative integer is present, multiply both numerator and denominator by -1 to ensure standard form is reached.
  For example, 3/-4 should be reduced to -3/4

  Assume that the programming language you are using does not have an implementation of rational numbers.
  """

  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, b1}, {a2, b2}), do: {a1 * b2 + b1 * a2, b1 * b2} |> reduce

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a1, b1}, {a2, b2}), do: {a1 * b2 - a2 * b1, b1 * b2} |> reduce

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, b1}, {a2, b2}), do: {a1 * a2, b1 * b2} |> reduce

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({a1, b1}, {a2, b2}), do: {a1 * b2, a2 * b1} |> reduce

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({a, b}), do: {Kernel.abs(a), Kernel.abs(b)} |> reduce

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({a, b}, n) when n > 0, do: {a ** n, b ** n} |> reduce

  def pow_rational({a, b}, n), do: {b ** Kernel.abs(n), a ** Kernel.abs(n)} |> reduce

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {a, b}), do: x ** (a / b)

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({a, b}), do: Integer.gcd(a, b) |> then(&{div(a, &1), div(b, &1)}) |> normalize

  defp normalize({numerator, denominator}) when denominator < 0, do: {-numerator, -denominator}

  defp normalize(fraction), do: fraction
end
