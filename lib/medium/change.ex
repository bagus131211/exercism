defmodule Exercism.Change do
  @moduledoc """
  Instructions
  Correctly determine the fewest number of coins to be given to a customer such that the sum of the coins' value would equal
  the correct amount of change.

  For example
    An input of 15 with [1, 5, 10, 25, 100] should return one nickel (5) and one dime (10) or [5, 10]
    An input of 40 with [1, 5, 10, 25, 100] should return one nickel (5) and one dime (10) and one quarter (25) or [5, 10, 25]
  Edge cases
    Does your algorithm work for any given set of coins?
    Can you ask for negative change?
    Can you ask for a change value smaller than the smallest coin value?
  """

  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """
  # -----------------------------Normal Iteration--------------------------------------
  # @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  # def generate(coins, target), do: coins |> Enum.sort(&>=/2) |> lowest_sum(target, [])

  # defp lowest_sum([], _target, _acc), do: {:error, "cannot change"}

  # defp lowest_sum(_coins, 0, acc), do: {:ok, acc}

  # defp lowest_sum([head | tail], target, acc) when head <= target, do: lowest_sum([head | tail], target - head, [head | acc])

  # defp lowest_sum([_head | tail], target, acc), do: lowest_sum(tail, target, acc)

  @spec generate(list(integer), integer) :: {:ok, list(integer)} | {:error, String.t()}
  def generate(_, target) when target < 0, do: {:error, "cannot change"}

  def generate(coins, target), do:
    List.duplicate(nil, target + 1)
      |> List.replace_at(0, [])
      |> then(&Enum.reduce(1..target, &1, fn current_target, acc -> update_memo(acc, coins, current_target) end))
      |> then(&case Enum.at(&1, target), do:
            (
              nil -> {:error, "cannot change"}
              result -> {:ok, result}
            )
         )

  defp update_memo(memo, coins, current_target), do:
    Enum.reduce(coins, memo, fn coin, acc ->
      if coin <= current_target, do:
        (
          previous_combination = acc |> Enum.at(current_target - coin)
          if previous_combination != nil, do:
            (
              new_combination = [coin | previous_combination]
              current_best = acc |> Enum.at(current_target)
              if current_best == nil or length(new_combination) < length(current_best), do:
                List.replace_at(acc, current_target, new_combination),
              else:
                acc
            ),
          else:
            acc
        ),
      else:
        acc
    end)
end
