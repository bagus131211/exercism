defmodule Exercism.Wordy do
  @operator %{"plus" => " + ", "minus" => " - ", "divided by" => " / ", "multiplied by" => " * "}
  @unsupported ~w(cubed squared)
  @doc """
  Calculate the math problem in the sentence.

    ## Example:

      iex(64)> Exercism.Wordy.answer "How much is 2 plus 4 plus 5?"
      11

      iex(65)> Exercism.Wordy.answer "How much is 2 plus 4 minus 5?"
      1

      iex(66)> Exercism.Wordy.answer "How much is 2 plus 4 divided by 2?"
      3

      iex(67)> Exercism.Wordy.answer "How much is 2 plus 4?"
      6

  """
  @spec answer(String.t()) :: integer
  def answer(question), do: (
    if question |> String.contains?(@unsupported),
      do:
        (raise ArgumentError),
      else:
      (
        ~r/-?\d+|#{@operator |> Map.keys |> Enum.join("|")}/
        |> Regex.scan(question)
        |> List.flatten
        |> set_parentheses
        |> Enum.reduce("", fn part, acc ->
          case @operator[part], do:
          (
            nil -> acc <> part
            operator -> acc <> operator
          )
        end)
        |> String.trim
        |> eval
      )
  )

  defp eval(expression), do: (
    try do
      expression |> Code.eval_string |> then(&round(elem(&1, 0)))
    catch
      :error, _ -> raise ArgumentError
    end
  )

  defp set_parentheses([head | tail]), do: set_parentheses(tail, head)

  defp set_parentheses([]), do: raise ArgumentError

  defp set_parentheses([second | [third | rest]], first), do: ["(#{first}", second, "#{third})" | rest]

  defp set_parentheses([_ | []], _), do: raise ArgumentError

  defp set_parentheses([], first), do: [first]
end
