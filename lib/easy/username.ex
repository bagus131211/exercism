defmodule Exercism.Username do
  @spec sanitize(charlist()) :: charlist()
  def sanitize(username), do: username |> subtitute |> Enum.filter(&(&1 in ?a..?z or &1 == ?_))

  defp subtitute([]), do: []
  defp subtitute([head | tail]) do
    replacement =
    case head do
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      _ -> [head]
    end

    replacement ++ subtitute(tail)
  end
end
