defmodule Exercism.AllYourBase do
  @moduledoc """
  Instructions
  Convert a sequence of digits in one base, representing a number, into a sequence of digits in another base, representing the same number.

  Note
  Try to implement the conversion yourself. Do not use something else to perform the conversion for you.

  About Positional Notation
  In positional notation, a number in base b can be understood as a linear combination of powers of b.

  The number 42, in base 10, means:

  (4 × 10¹) + (2 × 10⁰)

  The number 101010, in base 2, means:

  (1 × 2⁵) + (0 × 2⁴) + (1 × 2³) + (0 × 2²) + (1 × 2¹) + (0 × 2⁰)

  The number 1120, in base 3, means:

  (1 × 3³) + (1 × 3²) + (2 × 3¹) + (0 × 3⁰)

  Yes. Those three numbers above are exactly the same. Congratulations!
  """

  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """
  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_digits, input_base, _output_base) when input_base < 2, do: {:error, "input base must be >= 2"}

  def convert(_digits, _input_base, output_base) when output_base < 2, do: {:error, "output base must be >= 2"}

  def convert(_digits, input_base, output_base)
   when input_base < 2 and output_base < 2, do: {:error, "Both bases must be greater than or equal than 2"}

  def convert([], _input_base, _output_base), do: {:ok, [0]}

  def convert(digits, input_base, output_base) do
    if check_negative(digits, input_base) do
      {:error, "all digits must be >= 0 and < input base"}
    else
      digits
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.reduce(0, &sum_decimal(&1, &2, input_base))
    |> round
    |> Stream.unfold(&unfold(&1, output_base))
    |> Enum.reverse
    |> (case do: ([] -> [0]; digits -> digits))
    |> (&{:ok, &1}).()
    end
  end

  defp sum_decimal({digit, index}, acc, input), do: acc + digit * :math.pow(input, index)

  defp unfold(0, _), do: nil

  defp unfold(num, output), do: {rem(num, output), div(num, output)}

  defp check_negative(digits, input_base), do: digits |> Enum.any?(& &1 < 0 or &1 >= input_base)
end
