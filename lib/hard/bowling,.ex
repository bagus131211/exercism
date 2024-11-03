defmodule Exercism.Bowling do
  alias Exercism.Bowling
  @errors [
    score: "Score cannot be taken until the end of the game",
    roll: "Cannot roll after game is over",
    pin: "Pin count exceeds pins on the lane",
    negate: "Negative roll is invalid"
  ]

  defstruct [:score, :frame, :roll1, :roll2]

  @type t :: %Bowling{
    score: integer,
    frame: integer,
    roll1: integer | nil,
    roll2: integer | nil
  }

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: t
  def start, do: %Bowling{score: 0, frame: 1, roll1: nil, roll2: nil}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """
  @spec roll(t, integer) :: {:ok, t} | {:error, String.t}
  def roll(game, _roll) when game.frame >= 11, do: {:error, @errors[:roll]}

  def roll(_game, roll) when roll < 0, do: {:error, @errors[:negate]}

  def roll(_game, roll) when roll > 10, do: {:error, @errors[:pin]}

  def roll(%Bowling{roll1: roll1, roll2: nil}, roll) when roll1 !== 10 and roll1 + roll > 10, do: {:error, @errors[:pin]}

  def roll(%Bowling{roll1: 10, roll2: roll2}, roll) when roll2 !== 10 and roll2 + roll > 10, do: {:error, @errors[:pin]}

  # 1st roll
  def roll(%Bowling{roll1: nil} = game, roll), do: {:ok, %{game | roll1: roll}}

  # 2nd roll and have bonus
  def roll(%Bowling{roll1: roll1, roll2: nil} = game, roll) when roll1 === 10 or roll1 + roll === 10, do: {:ok, %{game | roll2: roll}}

  # 2nd roll and no bonus
  def roll(%Bowling{roll1: roll1, roll2: nil, score: score, frame: frame} = game, roll), do:
    {:ok, %{game | roll1: nil, score: score + roll1 + roll, frame: frame + 1}}

  # 3rd roll with strike before
  def roll(%Bowling{roll1: 10, roll2: roll2, score: score, frame: frame} = game, roll), do:
    {:ok, %{game | roll1: roll2, roll2: roll, score: score + 10 + roll2 + roll, frame: frame + 1}}

  # 3rd with spare before
  def roll(%Bowling{roll1: roll1, roll2: roll2, score: score, frame: frame} = game, roll), do:
    {:ok, %{game | roll1: roll, roll2: nil, score: score + roll1 + roll2 + roll, frame: frame + 1}}

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.

      ## Example:

        iex(78)> game9 = %Exercism.Bowling{rolls: [10, 10, 10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], frame: 10, complete: true}
        %Exercism.Bowling{
          rolls: [10, 10, 10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          frame: 10,
          complete: true
        }
        iex(79)> Exercism.Bowling.score game9
        {:ok, 81}

        iex(76)> game8 = %Exercism.Bowling{rolls: [10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], frame: 10, complete: true}
        %Exercism.Bowling{
          rolls: [10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          frame: 10,
          complete: true
        }
        iex(77)> Exercism.Bowling.score game8
        {:ok, 26}

        iex(74)> game7 = %Exercism.Bowling{rolls: [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], frame: 10.0, complete: true}
        %Exercism.Bowling{
          rolls: [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          frame: 10.0,
          complete: true
        }
        iex(75)> Exercism.Bowling.score game7
        {:ok, 10}

        iex(57)> game6 = %Exercism.Bowling{rolls: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 7], frame: 10, complete: true}
        %Exercism.Bowling{
          rolls: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 7],
          frame: 10,
          complete: true
        }
        iex(66)> Exercism.Bowling.score game6
        {:ok, 17}

  """
  @spec score(t) :: {:ok, integer} | {:error, String.t}
  def score(game) when game.frame <= 10, do: {:error, @errors[:score]}

  def score(game), do: {:ok, game.score}
end
