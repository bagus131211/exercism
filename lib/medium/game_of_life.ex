defmodule Exercism.GameOfLife do
  @moduledoc """
  Introduction
  Conway's Game of Life is a fascinating cellular automaton created by the British mathematician John Horton Conway in 1970.

  The game consists of a two-dimensional grid of cells that can either be "alive" or "dead."

  After each generation, the cells interact with their eight neighbors via a set of rules, which define the new generation.

  Instructions
  After each generation, the cells interact with their eight neighbors, which are cells adjacent horizontally, vertically, or diagonally.

  The following rules are applied to each cell:

    Any live cell with two or three live neighbors lives on.
    Any dead cell with exactly three live neighbors becomes a live cell.
    All other cells die or stay dead.
  Given a matrix of 1s and 0s (corresponding to live and dead cells), apply the rules to each cell, and return the next generation.
  """

  @doc """
  Apply the rules of Conway's Game of Life to a grid of cells

    Example:

      iex(6)> Exercism.GameOfLife.tick [[0,0,0],[0,1,0],[0,0,0]]
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
      iex(7)> Exercism.GameOfLife.tick [[0,0,0],[0,1,0],[0,1,0]]
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
      iex(8)> Exercism.GameOfLife.tick [[1,0,1],[1,0,1],[1,0,1]]
      [[0, 0, 0], [1, 0, 1], [0, 0, 0]]
      iex(9)> Exercism.GameOfLife.tick [[0, 1, 0], [1, 0, 0], [1, 1, 0]]
      [[0, 0, 0], [1, 0, 0], [1, 1, 0]]

  """
  @spec tick(matrix :: list(list(0 | 1))) :: list(list(0 | 1))
  def tick([]), do: []

  def tick(matrix), do:
    (
      for {row, index} <- matrix |> Enum.with_index, do:
        (
          for {cell, index2} <- row |> Enum.with_index, do:
          next(cell, count_neighbors(matrix, index, index2))
        )
    )

  defp count_neighbors(matrix, i, j) do
    neighbors = [
      {i - 1, j - 1}, {i - 1, j}, {i - 1, j + 1},
      {i, j - 1},                 {i, j + 1},
      {i + 1, j - 1}, {i + 1, j}, {i + 1, j + 1}
    ]
    neighbors |> Enum.map(& get_cell(matrix, &1)) |> Enum.sum
  end

  defp get_cell(matrix, {x, y}) when x >= 0 and y >= 0, do:
    (case matrix |> Enum.at(x), do:
      (
        nil -> 0
        row -> row |> Enum.at(y, 0)
      )
    )

  defp get_cell(_, _), do: 0

  defp next(1, live_neighbors) when live_neighbors in 2..3, do: 1

  defp next(1, _), do: 0

  defp next(0, 3), do: 1

  defp next(0, _), do: 0
end
