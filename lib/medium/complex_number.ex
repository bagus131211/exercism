defmodule Exercism.ComplexNumber do
  @moduledoc """
  A complex number is a number in the form a + b * i where a and b are real and i satisfies i^2 = -1.

  a is called the real part and b is called the imaginary part of z. The conjugate of the number a + b * i is the number a - b * i.
  The absolute value of a complex number
    z = a + b * i is a real number |z| = sqrt(a^2 + b^2).
  The square of the absolute value |z|^2 is the result of multiplication of z by its complex conjugate.

  The sum/difference of two complex numbers involves adding/subtracting their real and imaginary parts separately:
    (a + i * b) + (c + i * d) = (a + c) + (b + d) * i, (a + i * b) - (c + i * d) = (a - c) + (b - d) * i.

  Multiplication result is by definition
    (a + i * b) * (c + i * d) = (a * c - b * d) + (b * c + a * d) * i.

  The reciprocal of a non-zero complex number is
    1 / (a + i * b) = a/(a^2 + b^2) - b/(a^2 + b^2) * i.

  Dividing a complex number a + i * b by another c + i * d gives:
    (a + i * b) / (c + i * d) = (a * c + b * d)/(c^2 + d^2) + (b * c - a * d)/(c^2 + d^2) * i.

  Raising e to a complex exponent can be expressed as
    e^(a + i * b) = e^a * e^(i * b), the last term of which is given by Euler's formula e^(i * b) = cos(b) + i * sin(b).

  Implement the following operations:

  addition, subtraction, multiplication and division of two complex numbers,
  conjugate, absolute value, exponent of a given complex number.
  Assume the programming language you are using does not have an implementation of complex numbers.

  In this exercise, complex numbers are represented as a tuple-pair containing the real and imaginary parts.

  For example, the real number 1 is {1, 0}, the imaginary number i is {0, 1} and the complex number 4+3i is {4, 3}.
  """

  alias Exercism.ComplexNumber

  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {number, number}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: number
  def real({real, _imaginary}), do: real

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: number
  def imaginary({_real, imaginary}), do: imaginary

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | number, b :: complex | number) :: complex
  def mul({a, b}, {c, d}), do: {a * c - b * d, a * d + b * c}

  def mul({a, b}, real), do: {a * real, b * real}

  def mul(real, {a, b}), do: {real * a, real * b}

  def mul(real1, real2), do: {real1 * real2, 0}

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | number, b :: complex | number) :: complex
  def add({a, b}, {c, d}), do: {a + c, b + d}

  def add({a, b}, real), do: {a + real, b}

  def add(real, {a, b}), do: {a + real, b}

  def add(real1, real2), do: {real1 + real2, 0}

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | number, b :: complex | number) :: complex
  def sub({a, b}, {c, d}), do: {a - c, b - d}

  def sub({a, b}, real), do: {a - real, b}

  def sub(real, {a, b}), do: {real - a, -b}

  def sub(real1, real2), do: {real1 - real2, 0}

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | number, b :: complex | number) :: complex
  def div({a, b}, {c, d}) do
    denom = c * c + d * d
    {(a * c + b * d) / denom, (b * c - a * d) / denom}
  end

  def div({a, b}, real), do: {a / real, b / real}

  def div(real, {a, b}), do: ComplexNumber.div({real, 0}, {a, b})

  def div(real1, real2), do: {real1 / real2, 0}

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: number
  def abs({a, b}), do: :math.sqrt(a * a + b * b)

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({a, b}), do: {a, -b}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({a, b}), do: {:math.exp(a) * :math.cos(b), :math.exp(a) * :math.sin(b)}
end
