defmodule Exercism.Say do
  @moduledoc """
  Given a number from 0 to 999,999,999,999, spell out that number in English.

  Step 1
    Handle the basic case of 0 through 99.

    If the input to the program is 22, then the output should be 'twenty-two'.

    Your program should complain loudly if given a number outside the blessed range.

    Some good test cases for this program are:

      0
      14
      50
      98
      -1
      100
  Extension
    If you're on a Mac, shell out to Mac OS X's say program to talk out loud.
    If you're on Linux or Windows, eSpeakNG may be available with the command espeak.

  Step 2
    Implement breaking a number up into chunks of thousands.

    So 1234567890 should yield a list like 1, 234, 567, and 890,
    while the far simpler 1000 should yield just 1 and 0.

  Step 3
    Now handle inserting the appropriate scale word between those chunks.

    So 1234567890 should yield '1 billion 234 million 567 thousand 890'

    The program must also report any values that are out of range.
    It's fine to stop at "trillion".

  Step 4
    Put it all together to get nothing but plain English.

    12345 should give twelve thousand three hundred forty-five.

    The program must also report any values that are out of range.
  """

  @pronoun %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety",
    100 => "hundred",
    1_000 => "thousand",
    1_000_000 => "million",
    1_000_000_000 => "billion"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(0), do: {:ok, "zero"}

  def in_english(number) when number < 0 or number > 999_999_999_999, do:
    {:error, "number is out of range"}

  def in_english(number) when number < 20, do:
    {:ok, @pronoun[number]}

  def in_english(number) when number < 100, do:
    number
     |> Integer.digits
     |> then(&"#{@pronoun[Enum.at(&1, 0) * 10]}#{if Enum.at(&1, 1) !== 0, do: "-" <> @pronoun[Enum.at(&1, 1)]}")
     |> then(&{:ok, &1})

  def in_english(number) when number < 1_000, do:
     {:ok, "#{@pronoun[div(number, 100)]} hundred#{if rem(number, 100) !== 0, do: in_english(rem(number, 100)) |> elem(1) |> then(& " " <> &1)}"}

  def in_english(number), do:
    number
     |> Integer.digits
     |> Enum.reverse
     |> Enum.chunk_every(3)
     |> Enum.with_index
     |> Enum.reverse
     |> Enum.map(&spell_chunk/1)
     |> Enum.reject(&(&1 == ""))
     |> Enum.join(" ")
     |> String.trim
     |> then(& {:ok, &1})

  defp spell_chunk({chunk, idx}) do
    chunk |> Enum.reverse |> Integer.undigits |> (case do:
      (
        0 -> ""
        num -> "#{in_english(num) |> elem(1)} #{scale(idx)}"
      )
    )
  end

  defp scale(0), do: ""

  defp scale(1), do: @pronoun[1_000]

  defp scale(2), do: @pronoun[1_000_000]

  defp scale(3), do: @pronoun[1_000_000_000]
end
