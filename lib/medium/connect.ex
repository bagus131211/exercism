defmodule Exercism.Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player

    ## Example:

      iex(15)> Exercism.Connect.result_for [".O..","OXXX","OXO.","XXOX",".OX."]
      :black

      iex(16)> Exercism.Connect.result_for [".....",".....",".....",".....","....."]
      :none

      iex(17)> Exercism.Connect.result_for ["X"]
      :black

      iex(18)> Exercism.Connect.result_for ["O"]
      :white

      iex(19)> Exercism.Connect.result_for ["OOOX", "X..X", "X..X", "XOOO"]
      :none

  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    list = board |> Enum.map(&String.graphemes/1)
    height = list |> length
    width = list |> Enum.at(0) |> length

    cond do:
      (
        check_winner(list, "O", height, width, &top_bottom?/2) -> :white
        check_winner(list, "X", height, width, &left_right?/2) -> :black
        true -> :none
      )
  end

  defp top_bottom?({x, _}, height), do: x == height - 1

  defp left_right?({_, y}, width), do: y == width - 1

  defp check_winner(board, player, height, width, win_rule_fn), do:
    player
      |> starting_positions(height, width)
      |> Enum.any?(fn pos ->
          depth_first_search(board, pos, :ets.new(:visited, [:set, :public]), player, height, width, win_rule_fn)
      end)

  defp starting_positions("O", height, _width), do: (for x <- 0..height - 1, do: {0, x})

  defp starting_positions("X", _height, width), do: (for y <- 0..width - 1, do: {y, 0})

  defp depth_first_search(board, {x, y}, visited, player, height, width, win_rule_fn), do:
    (if :ets.lookup(visited, {x, y}) == [] and valid_move?(board, {x, y}, player, height, width), do:
      (
        :ets.insert(visited, {{x, y}, true})
        position = if player == "O", do: height, else: width
        (if win_rule_fn.({x, y}, position), do:
          true,
        else:
          neighbors(x, y, height, width)
          |> Enum.any?(fn {nx, ny} -> depth_first_search(board, {nx, ny}, visited, player, height, width, win_rule_fn) end)
        )),
    else:
     false
     )

  defp valid_move?(board, {x, y}, player, height, width), do:
    x >= 0 and x < height and y >= 0 and y < width and (board |> Enum.at(x) |> Enum.at(y)) == player

  defp neighbors(x, y, height, width), do:
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y + 1},
      {x + 1, y - 1}
    ]
    |> Enum.filter(fn {nx, ny} -> nx >= 0 and nx < height and ny >= 0 and ny < width end)
end
