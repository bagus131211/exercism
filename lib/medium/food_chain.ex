defmodule Exercism.FoodChain do
  @moduledoc """
  Generate the lyrics of the song 'I Know an Old Lady Who Swallowed a Fly'.

  While you could copy/paste the lyrics, or read them from a file,
  this problem is much more interesting if you approach it algorithmically.

  This is a cumulative song of unknown origin.

  This is one of many common variants.
  """

  @animals ~w(spider bird cat dog goat cow horse)
  @sounds ["It wriggled and jiggled and tickled inside her.",
            "How absurd to swallow a bird!",
            "Imagine that, to swallow a cat!",
            "What a hog, to swallow a dog!",
            "Just opened her throat and swallowed a goat!",
            "I don't know how she swallowed a cow!",
            "She's dead, of course!"
          ]
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop), do:
    start..stop
      |> Enum.map(&verse/1)
      |> Enum.join("\n")

  defp verse(1), do:
    """
    I know an old lady who swallowed a fly.
    I don't know why she swallowed the fly. Perhaps she'll die.
    """

  defp verse(8), do:
    """
    I know an old lady who swallowed a horse.
    She's dead, of course!
    """

  defp verse(n) do
    lines = ["I know an old lady who swallowed a #{@animals |> Enum.at(n - 2)}.", @sounds |> Enum.at(n - 2)]
    lines =
      if n > 2,
        do: Enum.reduce((n - 2)..1, lines, fn i, acc ->
              acc ++ ["She swallowed the #{@animals |> Enum.at(i)} to catch the #{@animals |> Enum.at(i - 1) |> animal}."]
            end),
        else: lines
    lines ++ ["She swallowed the spider to catch the fly.", "I don't know why she swallowed the fly. Perhaps she'll die.\n"] |> Enum.join("\n")
  end

  defp animal("spider"), do: "spider that wriggled and jiggled and tickled inside her"

  defp animal(anim), do: anim
end
