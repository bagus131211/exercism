defmodule Exercism.Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
  {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{year, month, day}, {hours, minutes, seconds}}), do:
    DateTime.new!(Date.new!(year, month, day), Time.new!(hours, minutes, seconds), "Etc/UTC")
    |> DateTime.add(1_000_000_000)
    |> (&{{&1.year, &1.month, &1.day}, {&1.hour, &1.minute, &1.second}}).()
end
