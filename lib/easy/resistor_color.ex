defmodule Exercism.ResistorColor do
  @doc """
  Return the value of a color band
  """
  @colors %{
  black: 0,
  brown: 1,
  red: 2,
  orange: 3,
  yellow: 4,
  green: 5,
  blue: 6,
  violet: 7,
  grey: 8,
  white: 9
  }

  @spec code(atom) :: integer()
  def code(color), do: @colors[color]
end
