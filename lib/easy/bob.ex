defmodule Exercism.Bob do
  @moduledoc """
  Your task is to determine what Bob will reply to someone when they say something to him or ask him a question.

  Bob only ever answers one of five things:

  "Sure." This is his response if you ask him a question, such as "How are you?" The convention used for questions is that it ends with a question mark.
  "Whoa, chill out!" This is his answer if you YELL AT HIM. The convention used for yelling is ALL CAPITAL LETTERS.
  "Calm down, I know what I'm doing!" This is what he says if you yell a question at him.
  "Fine. Be that way!" This is how he responds to silence. The convention used for silence is nothing, or various combinations of whitespace characters.
  "Whatever." This is what he answers to anything else.
  """
  @spec hey(String.t()) :: String.t()
  def hey(input), do:
    (cond do:
      (
        silence(input) -> "Fine. Be that way!"
        question(input) and yell(input) -> "Calm down, I know what I'm doing!"
        question(input) -> "Sure."
        yell(input) -> "Whoa, chill out!"
        true -> "Whatever."
      )
    )

  defp silence(input), do: input |> String.trim == ""

  defp question(input), do: input |> String.trim |> String.ends_with?("?")

  defp yell(input), do: String.upcase(input) == input and String.match?(input, ~r/\p{L}/)
end
