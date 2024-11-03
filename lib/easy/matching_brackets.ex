defmodule Exercism.MatchingBrackets do
  @moduledoc """
  You're given the opportunity to write software for the Bracketeer™,
  an ancient but powerful mainframe. The software that runs on it is written in a
  proprietary language. Much of its syntax is familiar,
  but you notice lots of brackets, braces and parentheses.
  Despite the Bracketeer™ being powerful, it lacks flexibility.
  If the source code has any unbalanced brackets, braces or parentheses,
  the Bracketeer™ crashes and must be rebooted. To avoid such a scenario,
  you start writing code that can verify that brackets, braces,
  and parentheses are balanced before attempting to run it on the Bracketeer™.

  Instructions
  Given a string containing brackets [], braces {}, parentheses (), or any combination thereof,
  verify that any and all pairs are matched and nested correctly.
  Any other characters should be ignored.
  For example, "{what is (42)}?" is balanced and "[text}" is not.
  """

  @brakets %{
    "(" => ")",
    "{" => "}",
    "[" => "]"
  }

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str), do:
    str
    |> String.graphemes
    |> Enum.reduce_while([], &reduce/2)
    |> (case do:
          (
            [] -> true
            _ -> false
          )
       )

  defp reduce(char, stack), do:
    (cond do:
      (
       char in Map.keys(@brakets) -> {:cont, [char | stack]}
       char in Map.values(@brakets) ->
        case pop_stack?(stack, char), do:
          (
            true -> {:cont, tl(stack)}
            _ -> {:halt, :error}
          )
       true -> {:cont, stack}
      )
    )

  defp pop_stack?([head | _], char), do: @brakets[head] == char

  defp pop_stack?([], _), do: false
end
