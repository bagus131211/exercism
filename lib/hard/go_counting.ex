defmodule Exercism.GoCounting do
  @type position :: {integer, integer}
  @type owner :: %{owner: atom, territory: [position]}
  @type territories :: %{white: [position], black: [position], none: [position]}
  @offsets [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

  @doc """
  Return the owner and territory around a position

    ## Example:

      iex(3)> Exercism.GoCounting.territory "__B__\n_B_B_\nB_W_B\n_W_W_\n__W__", {0, 1}
      {:ok, %{owner: :black, territory: [{0, 0}, {0, 1}, {1, 0}]}}

      iex(4)> Exercism.GoCounting.territory "__B__\n_B_B_\nB_W_B\n_W_W_\n__W__", {2, 3}
      {:ok, %{owner: :white, territory: [{2, 3}]}}

      iex(13)> Exercism.GoCounting.territory "__B__\n_B_B_\nB_W_B\n_W_W_\n__W__", {1, 4}
      {:ok, %{owner: :none, territory: [{0, 3}, {0, 4}, {1, 4}]}}

      iex(14)> Exercism.GoCounting.territory "__B__\n_B_B_\nB_W_B\n_W_W_\n__W__", {1, 1}
      {:ok, %{owner: :none, territory: []}}

      iex(15)> Exercism.GoCounting.territory "__B__\n_B_B_\nB_W_B\n_W_W_\n__W__", {-1, 1}
      {:error, "Invalid coordinate"}

      iex(16)> Exercism.GoCounting.territory "__B__\n_B_B_\nB_W_B\n_W_W_\n__W__", {5, 1}
      {:error, "Invalid coordinate"}

  """
  @spec territory(board :: String.t(), position :: position) ::
          {:ok, owner} | {:error, String.t()}
  def territory(board, {x, y}) do
    init_board = create_board(board)
    cond do
      not_on_board?(init_board, x, y) -> {:error, "Invalid coordinate"}
      entry(init_board, x, y) != ?_ -> {:ok, %{owner: :none, territory: []}}
      true ->
        {edges, fields} = territory(init_board, x, y, [])
        owner = case Enum.uniq(edges), do: (
          [?B] -> :black
          [?W] -> :white
          _ -> :none
        )
        {:ok, %{owner: owner, territory: fields |> Enum.uniq |> Enum.sort}}
    end
  end

  defp territory(board, x, y, list), do: (
    cond do
      not_on_board?(board, x, y) -> {[], []}
      {x, y} in list -> {[], []}
      true ->
        owner = entry(board, x, y)
        if owner != ?_, do: {[owner], []}, else: @offsets |> Enum.reduce({[], [{x, y}]}, fn {dx, dy}, {edges, fields} ->
          {de, df} = territory(board, x + dx, y + dy, [{x, y} | list])
          {edges ++ de, fields ++ df}
        end)
    end
  )

  defp create_board(board), do: board |> String.split("\n", trim: true) |> Enum.map(&String.to_charlist/1)

  defp not_on_board?(board, x, y), do: y < 0 or y >= length(board) or x < 0 or x >= length(List.first(board))

  defp entry(board, x, y), do: board |> Enum.at(y) |> Enum.at(x)

  @doc """
  Return all white, black and neutral territories

    ## Example:

      iex(21)> Exercism.GoCounting.territories "_"
      %{none: [{0, 0}], black: [], white: []}

      iex(22)> Exercism.GoCounting.territories "_BW_\n_BW_"
      %{none: [], black: [{0, 0}, {0, 1}], white: [{3, 0}, {3, 1}]}

      iex(23)> Exercism.GoCounting.territories "_B_"
      %{none: [], black: [{0, 0}, {2, 0}], white: []}

  """
  @spec territories(board :: String.t()) :: territories
  def territories(board) do
    init_board = board |> String.split("\n", trim: true)
    for y <- 0..length(init_board) - 1,
        x <- 0..String.length(List.first(init_board)) - 1 do
      territory(board, {x, y}) |> elem(1)
    end
    |> Enum.group_by(& &1.owner, & &1.territory)
    |> Map.new(fn {k, v} -> {k, v |> Enum.concat |> Enum.uniq |> Enum.sort} end)
    |> then(&Map.merge(%{black: [], none: [], white: []}, &1))
  end
end
