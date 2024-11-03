defmodule Exercism.House do
  @moduledoc """
  Recite the nursery rhyme 'This is the House that Jack Built'.

  [The] process of placing a phrase of clause within another phrase of clause is called embedding.
  It is through the processes of recursion and embedding that we are able to
  take a finite number of forms (words and phrases) and construct an infinite number of expressions.
  Furthermore, embedding also allows us to construct an infinitely long structure, in theory anyway.
  """

  @rhyme [
    "This is the house that Jack built.\n",
    "This is the malt that lay in the house that Jack built.\n",
    "This is the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n",
    "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
  ]

  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop), do: @rhyme |> Enum.slice(start - 1, stop - start + 1) |> Enum.join("")
end
