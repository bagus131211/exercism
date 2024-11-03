defmodule Exercism.TwelveDays do
  @moduledoc """
  Your task in this exercise is to write code that returns the lyrics of the song: "The Twelve Days of Christmas."

  "The Twelve Days of Christmas" is a common English Christmas carol. Each subsequent verse of the song builds on the previous verse.

  The lyrics your code returns should exactly match the full song text shown below.

  Lyrics
    On the first day of Christmas my true love gave to me: a Partridge in a Pear Tree.
    On the second day of Christmas my true love gave to me: two Turtle Doves, and a Partridge in a Pear Tree.
    On the third day of Christmas my true love gave to me: three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the fourth day of Christmas my true love gave to me: four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the fifth day of Christmas my true love gave to me: five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the sixth day of Christmas my true love gave to me: six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the seventh day of Christmas my true love gave to me: seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the eighth day of Christmas my true love gave to me: eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the ninth day of Christmas my true love gave to me: nine Ladies Dancing, eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the tenth day of Christmas my true love gave to me: ten Lords-a-Leaping, nine Ladies Dancing, eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the eleventh day of Christmas my true love gave to me: eleven Pipers Piping, ten Lords-a-Leaping, nine Ladies Dancing, eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
    On the twelfth day of Christmas my true love gave to me: twelve Drummers Drumming, eleven Pipers Piping, ten Lords-a-Leaping, nine Ladies Dancing, eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.
  """
  @lyrics %{
    1 => %{day: "first", qty: "a", gift: "Partridge in a Pear Tree."},
    2 => %{day: "second", qty: "two", gift: "Turtle Doves"},
    3 => %{day: "third", qty: "three", gift: "French Hens"},
    4 => %{day: "fourth", qty: "four", gift: "Calling Birds"},
    5 => %{day: "fifth", qty: "five", gift: "Gold Rings"},
    6 => %{day: "sixth", qty: "six", gift: "Geese-a-Laying"},
    7 => %{day: "seventh", qty: "seven", gift: "Swans-a-Swimming"},
    8 => %{day: "eighth", qty: "eight", gift: "Maids-a-Milking"},
    9 => %{day: "ninth", qty: "nine", gift: "Ladies Dancing"},
    10 => %{day: "tenth", qty: "ten", gift: "Lords-a-Leaping"},
    11 => %{day: "eleventh", qty: "eleven", gift: "Pipers Piping"},
    12 => %{day: "twelfth", qty: "twelve", gift: "Drummers Drumming"}
  }

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number), do:
    1..number
     |> Enum.reduce({"", []}, &previous/2)
     |> create_lyric

  defp previous(day, {_day_str, acc}), do: @lyrics[day] |> then(& {&1.day, ["#{&1.qty} #{&1.gift}" | acc]})

  defp create_lyric({day, gifts}), do: "On the #{day} day of Christmas my true love gave to me: " <> rearrange_lyric(gifts)

  defp rearrange_lyric(gifts), do:
    (
      case gifts |> Enum.reverse, do:
        (
          [] -> ""
          [single] -> single
          [head | tail] -> Enum.join(tail |> Enum.reverse, ", ") <> ", and " <> head
        )
    )

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse), do: starting_verse..ending_verse |> Enum.map_join("\n", &verse/1)

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing, do: verses(1, 12)
end
