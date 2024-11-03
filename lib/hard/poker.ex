defmodule Exercism.Poker do
  @ranks %{
    :straight_flush => 8,
    :four_of_a_kind => 7,
    :full_house => 6,
    :flush => 5,
    :straight => 4,
    :three_of_a_kind => 3,
    :two_pair => 2,
    :one_pair => 1,
    :high_card => 0
  }

  @hand %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s

    ## Example:

      iex(17)> Exercism.Poker.best_hand [~w(4S 5S 7H 8D JC)]
      [["4S", "5S", "7H", "8D", "JC"]]                        # high of jack

      iex(64)> Exercism.Poker.best_hand [~w(4D 5S 6S 8D 3C), ~w(2S 4C 7S 9H 10H), ~w(3S 4S 5D 6H JH)]
      [["3S", "4S", "5D", "6H", "JH"]]                        # high of 8 vs high of 10 vs high of jack = high of jack

      iex(65)> Exercism.Poker.best_hand [~w(4D 5S 6S 8D 3C), ~w(2S 4C 7S 9H 10H), ~w(3S 4S 5D 6H JH), ~w(3H 4H 5C 6C JD)]
      [["3S", "4S", "5D", "6H", "JH"], ["3H", "4H", "5C", "6C", "JD"]]

      iex(73)> Exercism.Poker.best_hand [~w(2S 5D 6D 8C 7S), ~w(3S 5H 6S 8D 7H)]
      [["3S", "5H", "6S", "8D", "7H"]]                        # max until last number

      iex(75)> Exercism.Poker.best_hand [~w(2S 5H 6S 8D 7H), ~w(3S 4D 6D 8C 7S)]
      [["2S", "5H", "6S", "8D", "7H"]]                        # even have the lowest its still win because 5 is greater than 4

      iex(76)> Exercism.Poker.best_hand [~w(4S 5H 6C 8D KH), ~w(2S 4H 6S 4D JH)]
      [["2S", "4H", "6S", "4D", "JH"]]                        # one pair beat high of card

      iex(95)> Exercism.Poker.best_hand [~w(2S 8H 2H 8D JH), ~w(4S 5H 4C 8S 4H)]
      [["4S", "5H", "4C", "8S", "4H"]]                        # three of a kind against two pair

      iex(112)> Exercism.Poker.best_hand [~w(2H 3C 4D 5D 6H), ~w(4S AH 3S 2D 5H)]
      [["2H", "3C", "4D", "5D", "6H"]]                        # double straight but ace in straight count as 1 not 14

      iex(115)> Exercism.Poker.best_hand [~w(4S 5H 4C 8D 4H), ~w(10D JH QS KD AC)]
      [["10D", "JH", "QS", "KD", "AC"]]                       # straight against three of a kind

      iex(135)> Exercism.Poker.best_hand [~w(2S 2H 2C 8D 2D), ~w(4S 5H 5S 5D 5C)]
      [["4S", "5H", "5S", "5D", "5C"]]                        # four of a kind but get the most high number which is 5

  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands), do:
    hands
      |> Enum.map(& {&1, evaluate(&1)})
      |> IO.inspect
      |> Enum.group_by(fn {_hand, {rank, _}} -> rank end)
      |> Enum.max_by(fn {rank, _hands} ->  rank end)
      |> elem(1)
      |> highest_value

  defp highest_value(hands) do
    if length(hands) > 1 do
    max = hands |> Enum.map(fn {_hand, {_rank, value}} ->
      sorted = value |> Enum.frequencies |> Enum.sort_by(fn {rank, count} -> {-count, -rank} end)
      sorted |> Enum.map(&elem(&1, 0))
      end) |> Enum.max

    hands
      |> Enum.filter(fn {_hand, {_rank, value}} ->
        sorted = value |> Enum.frequencies |> Enum.sort_by(fn {rank, count} -> {-count, -rank} end)
        (sorted |> Enum.map(&elem(&1, 0))) == max
      end)
      |> Enum.map(fn {hand, _} ->  hand end)
    else
      hands |> Enum.map(fn {hand, _} ->  hand end)
    end
  end

  defp evaluate(hand) do
    {ranks, suits} = hand |> Enum.map(&parse_card/1) |> Enum.unzip
    cond do
      full_house?(ranks) -> {@ranks.full_house, ranks}
      two_pair?(ranks) -> {@ranks.two_pair, ranks}
      one_pair?(ranks) -> {@ranks.one_pair, ranks}
      three_of_a_kind?(ranks) -> {@ranks.three_of_a_kind, ranks}
      straight_flush?(ranks, suits) -> {@ranks.straight_flush, (if ranks |> Enum.sort == [2,3,4,5,14], do: [1,2,3,4,5], else: ranks)}
      straight?(ranks) -> {@ranks.straight, (if ranks |> Enum.sort == [2,3,4,5,14], do: [1,2,3,4,5], else: ranks)}
      flush?(suits) -> {@ranks.flush, ranks}
      four_of_a_kind?(ranks) -> {@ranks.four_of_a_kind, ranks}
      true -> {@ranks.high_card, ranks}
    end
  end

  defp parse_card(card) do
    [rank, suit] = Regex.run(~r/(\d+|[JQKA])([CDHS])/, card, capture: :all_but_first)
    {@hand[rank], suit}
  end

  defp straight_flush?(ranks, suits), do: flush?(suits) and straight?(ranks)

  defp four_of_a_kind?(ranks), do: ranks |> Enum.frequencies |> Enum.any?(fn {_rank, count} -> count == 4 end)

  defp full_house?(ranks), do:
    ranks |> Enum.frequencies |> Enum.count(fn {_rank, count} -> count == 3 end) |> Kernel.==(1) &&
    ranks |> Enum.frequencies |> Enum.count(fn {_rank, count} -> count == 2 end) |> Kernel.==(1)

  defp flush?(suits), do: suits |> Enum.uniq |> length |> Kernel.==(1)

  defp straight?(ranks) do
    sort = ranks |> Enum.sort
    sort |> Enum.chunk_every(2, 1, :discard) |> Enum.all?(fn [a, b] ->
      b - a == 1
    end) || sort == [2,3,4,5,14]
  end

  defp three_of_a_kind?(ranks), do: ranks |> Enum.frequencies |> Enum.any?(fn {_rank, count} -> count == 3 end)

  defp two_pair?(ranks), do: ranks |> Enum.frequencies |> Enum.count(fn {_rank, count} -> count == 2 end) |> Kernel.==(2)

  defp one_pair?(ranks), do: ranks |> Enum.frequencies |> Enum.any?(fn {_rank, count} -> count == 2 end)
end
