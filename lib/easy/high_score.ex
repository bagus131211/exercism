defmodule Exercism.HighScore do
  def new, do: %{}

  def add_player(scores, name, score \\ 0), do: scores |> Map.put(name, score)

  def remove_player(scores, name), do: scores |> Map.delete(name)

  def reset_score(scores, name), do: scores |> Map.update(name, 0, fn _ -> 0 end)

  def update_score(scores, name, score), do: scores |> Map.update(name, score, &(&1 + score))

  def get_players(scores), do: scores |> Map.keys
end
