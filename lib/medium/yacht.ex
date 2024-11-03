defmodule Exercism.Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.

    Example:

      iex(8)> Exercism.Yacht.score :yacht, [3,3,3,3,3]
      50
      iex(11)> Exercism.Yacht.score :ones, [1,1,3,2,1]
      3
      iex(13)> Exercism.Yacht.score :twos, [4,5,3,2,6]
      2
      iex(15)> Exercism.Yacht.score :threes, [3,3,3,3,3]
      15
      iex(16)> Exercism.Yacht.score :fours, [1,4,1,4,1]
      8

  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(:ones, dice), do: count_appearance(dice, 1) * 1

  def score(:twos, dice), do: count_appearance(dice, 2) * 2

  def score(:threes, dice), do: count_appearance(dice, 3) * 3

  def score(:fours, dice), do: count_appearance(dice, 4) * 4

  def score(:fives, dice), do: count_appearance(dice, 5) * 5

  def score(:sixes, dice), do: count_appearance(dice, 6) * 6

  def score(:full_house, dice), do:
    dice
      |> group_appearance
      |> then(&cond do:
                (
                  length(&1) == 2 and Enum.any?(&1, fn {_, b} -> b == 3 end) -> dice |> Enum.sum
                  true -> 0
                )
            )

  def score(:four_of_a_kind, dice), do:
   dice
    |> group_appearance
    |> then(&case Enum.find(&1, fn {_, b} -> b >= 4 end), do:
        (
          {a, _} -> a * 4
          _ -> 0
        )
       )

  def score(:little_straight, dice), do: dice |> Enum.sort |> Kernel.==([1,2,3,4,5]) |> (case do: (true -> 30; _ -> 0))

  def score(:big_straight, dice), do: dice |> Enum.sort |> Kernel.==([2,3,4,5,6]) |> (case do: (true -> 30; _ -> 0))

  def score(:choice, dice), do: dice |> Enum.sum

  def score(:yacht, dice), do: dice |> Enum.uniq |> length |> Kernel.==(1) |> (case do: (true -> 50; _ -> 0))

  defp count_appearance(dice, number), do: dice |> Enum.count(& &1 == number)

  defp group_appearance(dice), do: dice |> Enum.group_by(& &1) |> Enum.map(fn {number, occ} -> {number, occ |> length} end)
end
