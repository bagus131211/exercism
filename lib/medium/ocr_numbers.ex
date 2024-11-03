defmodule Exercism.OcrNumbers do
  @moduledoc """
  Step One
    To begin with, convert a simple binary font to a string containing 0 or 1.

    The binary font uses pipes and underscores, four rows high and three columns wide.

         _   #
        | |  # zero.
        |_|  #
             # the fourth row is always blank
      Is converted to "0"

             #
          |  # one.
          |  #
             # (blank fourth row)
      Is converted to "1"

    If the input is the correct size, but not recognizable, your program should return '?'

    If the input is the incorrect size, your program should return an error.

  Step Two
    Update your program to recognize multi-character binary strings, replacing garbled numbers with ?

  Step Three
    Update your program to recognize all numbers 0 through 9, both individually and as part of a larger string.

         _
         _|
        |_

    Is converted to "2"

        _  _     _  _  _  _  _  _  #
      | _| _||_||_ |_   ||_||_|| | # decimal numbers.
      ||_  _|  | _||_|  ||_| _||_| #
                                   # fourth line is always blank
    Is converted to "1234567890"

  Step Four
    Update your program to handle multiple numbers, one per line. When converting several lines, join the lines with commas.

          _  _
        | _| _|
        ||_  _|

            _  _
        |_||_ |_
          | _||_|

         _  _  _
          ||_||_|
          ||_| _|

    Is converted to "123,456,789".
  """

  @digit_map %{
    " _ | ||_|" => "0",
    "     |  |" => "1",
    " _  _||_ " => "2",
    " _  _| _|" => "3",
    "   |_|  |" => "4",
    " _ |_  _|" => "5",
    " _ |_ |_|" => "6",
    " _   |  |" => "7",
    " _ |_||_|" => "8",
    " _ |_| _|" => "9"
  }

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.

    Example:

      iex(125)> Exercism.OcrNumbers.convert [    "    _  _ ",    "  | _| _|",    "  ||_  _|",    "         ",    "    _  _ ",    "|_||_ |_ ",    "  | _||_|",    "         ",    " _  _  _ ",    "  ||_||_|",    "  ||_| _|",    "         "  ]
      {:ok, "123,456,789"}

      iex(126)> Exercism.OcrNumbers.convert [        "    _  _     _  _  _  _  _  _ ",        "  | _| _||_||_ |_   ||_||_|| |",        "  ||_  _|  | _||_|  ||_| _||_|",        "                              "      ]
      {:ok, "1234567890"}

      iex(127)> Exercism.OcrNumbers.convert [" _ ", " _|", "|_ ","   "]
      {:ok, "2"}

  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) when rem(length(input), 4) != 0, do: {:error, "invalid line count"}

  def convert(input), do:
    (if Enum.any?(input, & &1 |> String.length |> rem(3) !== 0),
      do:
        {:error, "invalid column count"},
      else:
        input
          |> Enum.chunk_every(4)
          |> Enum.map(&into_digits/1)
          |> Enum.join(",")
          |> then(&{:ok, &1})
    )

  defp into_digits([line1, line2, line3, _]), do:
    0..(line1 |> String.length |> div(3)) - 1
      |> Enum.map(&slice_digit(line1, line2, line3, &1))
      |> Enum.map(&convert_digit/1)
      |> Enum.join

  defp slice_digit(line1, line2, line3, index) do
    start = index * 3
    pt1 = String.slice(line1, start, 3)
    pt2 = String.slice(line2, start, 3)
    pt3 = String.slice(line3, start, 3)

    pt1 <> pt2 <> pt3
  end

  defp convert_digit(digit), do:
    (
      case @digit_map[digit], do:
      (
        nil -> "?"
        num -> num
      )
    )
end
