defmodule Exercism.Minesweeper do
  @moduledoc """
  Introduction
    Minesweeper is a popular game where the user has to find the mines using numeric hints that indicate how many mines are
    directly adjacent (horizontally, vertically, diagonally) to a square.

  Instructions
    Your task is to add the mine counts to empty squares in a completed Minesweeper board.
    The board itself is a rectangle composed of squares that are either empty (' ') or a mine ('*').

    For each empty square, count the number of mines adjacent to it (horizontally, vertically, diagonally).
    If the empty square has no adjacent mines, leave it empty. Otherwise replace it with the adjacent mines count.

    For example, you may receive a 5 x 4 board like this (empty spaces are represented here with the '·' character for display on screen):

        ·*·*·
        ··*··
        ··*··
        ·····
    Which your code should transform into this:

        1*3*1
        13*31
        ·2*2·
        ·111·
  """

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.

    ## Example:

      iex(3)> Exercism.Minesweeper.annotate []
      []

      iex(4)> Exercism.Minesweeper.annotate [""]
      [""]

      iex(5)> Exercism.Minesweeper.annotate ["   ","   ","   "]
      ["   ", "   ", "   "]

      iex(6)> Exercism.Minesweeper.annotate ["***","***","***"]
      ["***", "***", "***"]

      iex(7)> Exercism.Minesweeper.annotate ["   "," * ","   "]
      ["111", "1*1", "111"]

      iex(8)> Exercism.Minesweeper.annotate ["***","* *","***"]
      ["***", "*8*", "***"]

      iex(9)> Exercism.Minesweeper.annotate [" * * "]
      ["1*2*1"]

      iex(10)> Exercism.Minesweeper.annotate ["*  *"]
      ["*11*"]

      iex(11)> Exercism.Minesweeper.annotate ["*   *"]
      ["*1 1*"]

      iex(12)> Exercism.Minesweeper.annotate ["  *  ","  *  ", "*****","  *  ","  *  "]
      [" 2*2 ", "25*52", "*****", "25*52", " 2*2 "]

  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate(board), do:
    board
      |> Stream.with_index
      |> Stream.map(&numbers_near_mine(&1, board))
      |> Enum.to_list

  defp numbers_near_mine({row, row_index}, board), do:
    row
      |> String.graphemes
      |> Stream.with_index
      |> Stream.map(fn
          {"*", _} -> "*"
          {" ", column_index} -> count_adjacent_mines(board, row_index, column_index)
        end)
      |> Enum.join

  defp count_adjacent_mines(board, row_index, column_index), do:
    [
      {-1, -1}, {-1, 0}, {-1, 1},
      {0, -1},           {0, 1},
      {1, -1},  {1, 0},  {1, 1}
    ]
    |> Enum.count(fn {dx, dy} -> check_mine(board, row_index + dx, column_index + dy) end)
    |> (case do:
        (
          0 -> " "
          count -> to_string(count)
        )
       )

  defp check_mine(_, row, column) when row < 0 or column < 0, do: false

  defp check_mine(board, row, column), do:
    (
      case board |> Enum.at(row), do:
      (
        nil -> false
        line -> case line |> String.at(column), do:
        (
          "*" -> true
          _ -> false
        )
      )
    )
end
