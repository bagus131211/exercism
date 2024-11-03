defmodule Exercism.BasketballWebsite do

  def get_in_path(data, path), do: data |> get_in(path |> String.split("."))

  def extract_from_path(data, path), do: path |> String.split(".") |> extract(data)

  defp extract([], data), do: data

  defp extract([head | tail], data), do: (case data[head], do: (nil -> nil; value -> extract(tail, value)))
end
