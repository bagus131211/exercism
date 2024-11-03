defmodule Exercism.Rectangles do
  @moduledoc """
  Instructions
    Count the rectangles in an ASCII diagram like the one below.

          +--+
          ++  |
        +-++--+
        |  |  |
        +--+--+

    The above diagram contains these 6 rectangles:
        +-----+
        |     |
        +-----+

          +--+
          |  |
          |  |
          |  |
          +--+

          +--+
          |  |
          +--+

          +--+
          |  |
          +--+

          +--+
          |  |
          +--+

            ++
            ++

    You may assume that the input is always a proper rectangle (i.e. the length of every line equals the length of the first line).
  """
  @doc """
  Count the number of ASCII rectangles.

    ## Example:

      iex(5)> Exercism.Rectangles.count "+-+\n| |\n+-+"
      1

      iex(6)> Exercism.Rectangles.count ""
      0

      iex(7)> Exercism.Rectangles.count "\n"
      0

      iex(8)> Exercism.Rectangles.count "\s"
      0

      iex(9)> Exercism.Rectangles.count "  +-+\n  | |\n+-+-+\n| | \s\n+-+ \s"
      2

      iex(34)> Exercism.Rectangles.count "++\n++"
      1

      iex(35)> Exercism.Rectangles.count "+--+\n+--+"
      1

      iex(101)> Exercism.Rectangles.count "+------+----+\n|      |    |\n+------+    |\n|   |       |\n+---+-------+\n"
      2

      iex(102)> Exercism.Rectangles.count "+---+--+----+\n|   +--+----+\n+---+--+    |\n|   +--+----+\n+---+--+--+-+\n+---+--+--+-+\n+------+  | |\n
          +-+\n"
      60

  """
  @spec count(input :: String.t()) :: integer
  def count(input) do
    grid = input |> parse
    corners = grid |> get_corners
    count_rectangles(corners, grid)
  end

  defp parse(input), do: input |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

  defp get_corners(parse_result), do: (
    for {row, y} <- parse_result |> Enum.with_index,
        {char, x} <- row |> Enum.with_index,
        char == "+",
        do: {x, y}
  )

  defp count_rectangles(corners, grid), do:
    corners
      |> Enum.reduce(0, fn {x1, y1}, acc ->
            acc + Enum.count(corners, fn {x2, y2} ->
              x1 < x2 and y1 < y2 and rectangle?({x1, y1}, {x2,y2}, grid)
            end)
         end)

  defp rectangle?({x1, y1}, {x2, y2}, grid), do:
    (if length(grid) == 2, do:
      horizontal?(x1, x2, y1, grid) and horizontal?(x1, x2, y2, grid),  # Handle height 1 case
    else:
      another_corner?(y1, x2, grid) and another_corner?(y2, x1, grid) and
      horizontal?(x1, x2, y1, grid) and horizontal?(x1, x2, y2, grid) and
      vertical?(y1, y2, x1, grid) and vertical?(y1, y2, x2, grid)
    )

  defp horizontal?(x1, x2, y, grid), do: x1 + 1..x2 - 1 |> Enum.all?(&grid |> Enum.at(y) |> Enum.at(&1) |> Kernel.in(["-","+"]))

  defp vertical?(y1, y2, x, grid), do: y1 + 1..y2 - 1 |> Enum.all?(&grid |> Enum.at(&1) |> Enum.at(x) |> Kernel.in(["|","+"]))

  defp another_corner?(y, x, grid), do: grid |> Enum.at(y) |> Enum.at(x) |> Kernel.==("+")
end
