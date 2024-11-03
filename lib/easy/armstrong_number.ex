defmodule Exercism.ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @doc """
  Checks if the given `number` is an Armstrong number.

  An Armstrong number (also known as a narcissistic number) is an integer such that the sum of its own digits each raised to the power of the number of digits equals the number itself. For example:

  - 153 is an Armstrong number because \(1^3 + 5^3 + 3^3 = 153\).
  - 9474 is an Armstrong number because \(9^4 + 4^4 + 7^4 + 4^4 = 9474\).

  ## Parameters

  - `number`: An integer to be checked.

  ## Returns

  - `true` if `number` is an Armstrong number.
  - `false` otherwise.

  ## Examples

      iex> Exercism.ArmstrongNumber.valid?(153)
      true

      iex> Exercism.ArmstrongNumber.valid?(9474)
      true

      iex> Exercism.ArmstrongNumber.valid?(123)
      false

      iex> Exercism.ArmstrongNumber.valid?(10)
      false

  """
  @spec valid?(integer) :: boolean
  def valid?(number) do
    count = Integer.digits(number) |> length
    number
    |> Integer.digits
    |> Enum.reduce(0, & &2 + Integer.pow(&1, count))
    |> trunc
    |> Kernel.==(number)
  end
end
