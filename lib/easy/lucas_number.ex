defmodule Exercism.LucasNumber do
  def generate(count) when not is_integer(count) or count < 1, do:
   (raise ArgumentError, "count must be specified as an integer >= 1")

  def generate(count), do:
    {2, 1}
    |> Stream.unfold(fn {x, y} -> {x, {y, x + y}} end)
    |> Enum.take(count)
end
