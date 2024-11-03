defmodule Exercism.Clock do
  alias Exercism.Clock
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: %Clock{}
  def new(hour, minute), do:
   hour * 60 + minute
    |> rem(1440)
    |> (& if &1 < 0, do: &1 + 1440, else: &1).()
    |> (& %Clock{hour: div(&1, 60), minute: rem(&1, 60)}).()

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(%Clock{}, integer) :: %Clock{}
  def add(%Clock{hour: hour, minute: minute}, add_minute), do: new(hour, minute + add_minute)
end

defimpl String.Chars, for: Exercism.Clock do
  def to_string(clock) do
    str_hour = Integer.to_string(clock.hour) |> String.pad_leading(2, "0")
    str_minute = Integer.to_string(clock.minute) |> String.pad_leading(2, "0")
    "#{str_hour}:#{str_minute}"
  end
end
