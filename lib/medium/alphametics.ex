defmodule Exercism.Alphametics do
  @moduledoc """
  Instructions
  Given an alphametics puzzle, find the correct solution.

  Alphametics is a puzzle where letters in words are replaced with numbers.

  For example SEND + MORE = MONEY:

        S E N D
        M O R E +
      -----------
      M O N E Y
  Replacing these with valid numbers gives:

        9 5 6 7
        1 0 8 5 +
      -----------
      1 0 6 5 2
  This is correct because every letter is replaced by a different number and the words, translated into numbers, then make a valid sum.

  Each letter must represent a different digit, and the leading digit of a multi-digit number must not be zero.
  """

  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil

    ex(9)> Exercism.Alphametics.solve "AND + A + STRONG + OFFENSE + AS + A + GOOD == DEFENSE"
    %{"A" => 5, "D" => 3, "E" => 4, "F" => 7, "G" => 8, "N" => 0, "O" => 2, "R" => 1, "S" => 6, "T" => 9}

    iex(10)> Exercism.Alphametics.solve "SEND + MORE == MONEY"
    %{"D" => 7, "E" => 5, "M" => 1, "N" => 6, "O" => 0, "R" => 8, "S" => 9, "Y" => 2}

  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    [left, right] = puzzle |> String.split(" == ")
    left_chars = left |> String.split(" + ") |> Stream.map(&String.graphemes/1) |> Enum.to_list
    right_chars = right |> String.graphemes

    letters = [right_chars | left_chars] |> Stream.concat |> Enum.uniq
    leading_letter = [right_chars | left_chars] |> Stream.map(&hd/1) |> Enum.uniq

    backtrack(letters, leading_letter, %{}, {left_chars, right_chars})
  end

  defp backtrack([], _, assign, {left, right}), do:
    left |> Stream.map(&num(&1, assign)) |> Enum.sum |> Kernel.==(num(right, assign)) |> (
      case do:
      (
        true -> assign
        _ -> nil
      )
    )

  defp backtrack([head | tail], leading_letter, assign, words), do:
    Enum.find_value(0..9, fn digit ->
      if not leading_digit_violation?(digit, head, leading_letter) and enforce_constraints?(digit, assign), do:
        (
          new_assign = Map.put(assign, head, digit)
          backtrack(tail, leading_letter, new_assign, words)
        )
    end)

  defp leading_digit_violation?(digit, letter, leads), do: digit == 0 and letter in leads

  defp enforce_constraints?(digit, assign), do: digit not in Map.values(assign)

  defp num(word, assign), do: word |> Stream.map(&assign[&1]) |> Enum.to_list |> Integer.undigits
end
