defmodule Exercism.Prime do
  @moduledoc """
  Given a number n, determine what the nth prime is.

  By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

  If your language provides methods in the standard library to deal with prime numbers, pretend they don't exist and implement them yourself.
  """

  @doc """
  Generates the nth prime.
  """
  @spec nth(pos_integer) :: non_neg_integer
  def nth(count) when count > 0, do:
   2 |> Stream.unfold(&next/1) |> Stream.take(count) |> Enum.to_list |> List.last

  defp next(start), do:
   start |> Stream.iterate(&(&1 + 1)) |> Enum.find(&prime?/1) |> (&{&1, &1 + 1}).()

  defp prime?(2), do: true
  defp prime?(3), do: true
  defp prime?(x) when x < 2, do: false
  defp prime?(x), do: 2..trunc(:math.sqrt(x)) |> Enum.all?(&rem(x, &1) != 0)
end
