defmodule Exercism.Tournament do
  @moduledoc """
  Tally the results of a small football competition.

  Based on an input file containing which team played against which and what the outcome was, create a file with a table like this:

    Team                           | MP |  W |  D |  L |  P
    Devastating Donkeys            |  3 |  2 |  1 |  0 |  7
    Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
    Blithering Badgers             |  3 |  1 |  0 |  2 |  3
    Courageous Californians        |  3 |  0 |  1 |  2 |  1
  What do those abbreviations mean?

    MP: Matches Played
    W: Matches Won
    D: Matches Drawn (Tied)
    L: Matches Lost
    P: Points
  A win earns a team 3 points. A draw earns 1. A loss earns 0.

  The outcome is ordered by points, descending. In case of a tie, teams are ordered alphabetically.

  Input
    Your tallying program will receive input that looks like:

      Allegoric Alaskans;Blithering Badgers;win
      Devastating Donkeys;Courageous Californians;draw
      Devastating Donkeys;Allegoric Alaskans;win
      Courageous Californians;Blithering Badgers;loss
      Blithering Badgers;Devastating Donkeys;loss
      Allegoric Alaskans;Courageous Californians;win
  The result of the match refers to the first team listed. So this line:

    Allegoric Alaskans;Blithering Badgers;win
    means that the Allegoric Alaskans beat the Blithering Badgers.

  This line:

    Courageous Californians;Blithering Badgers;loss
    means that the Blithering Badgers beat the Courageous Californians.

  And this line:

    Devastating Donkeys;Courageous Californians;draw
    means that the Devastating Donkeys and Courageous Californians tied.
  """

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.

    Example:

      iex(17)> Exercism.Tournament.tally ["Blithering Badgers;Allegoric Alaskans;loss"]
      "Team                               | MP | W | D | L | P\n
       Allegoric Alaskans                 |  1 |  1 |  0 |  0 |  3\n
       Blithering Badgers                 |  1 |  0 |  0 |  1 |  0"

  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally([]), do: header()
  def tally(input), do:
    input
     |> Enum.reduce(%{}, &calculate_match/2)
     |> format

  defp calculate_match(input, acc), do:
    (case String.split(input, ";"), do:
      (
        [home, away, fixture] -> acc |> fixtures(home, fixture) |> fixtures(away, opposite(fixture))
        _ -> acc
      )
    )

  defp fixtures(acc, team, fixture) do
    %{mp: mp, w: w, d: d, l: l, pts: pts} = Map.get(acc, team, %{mp: 0, w: 0, d: 0, l: 0, pts: 0})
    stats = case fixture do
      "win" -> %{mp: mp + 1, w: w + 1, d: d, l: l, pts: pts + 3}
      "draw" -> %{mp: mp + 1, w: w, d: d + 1, l: l, pts: pts + 1}
      "loss" -> %{mp: mp + 1, w: w, d: d, l: l + 1, pts: pts}
      _ -> %{mp: mp, w: w, d: d, l: l, pts: pts}
    end
    Map.put(acc, team, stats)
  end

  defp format(results), do:
    results
      |> Stream.reject(fn {_, stats} -> stats.mp == 0 end)
      |> Enum.sort_by(fn {team, stats} -> {-stats.pts, team} end)
      |> Enum.map_join("\n", &standings/1)
      |> header

  defp standings({team, stats}), do:
    String.pad_trailing(team, 31) <> "| " <>
    String.pad_leading(to_string(stats.mp), 2) <> " | " <>
    String.pad_leading(to_string(stats.w), 2) <> " | " <>
    String.pad_leading(to_string(stats.d), 2) <> " | " <>
    String.pad_leading(to_string(stats.l), 2) <> " | " <>
    String.pad_leading(to_string(stats.pts), 2)

  defp opposite("win"), do: "loss"

  defp opposite("loss"), do: "win"

  defp opposite("draw"), do: "draw"

  defp opposite(_), do: nil

  defp header, do: "Team                           | MP |  W |  D |  L |  P"

  defp header(result), do: "#{header()}\n#{result}"
end
