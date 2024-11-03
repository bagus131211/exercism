defmodule Exercism.BowlingV1 do
  alias Exercism.BowlingV1

  defstruct [:rolls, :frame, :complete]

  @type t :: %BowlingV1{
    rolls: [integer],
    frame: integer,
    complete: boolean
  }

   @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: t
  def start, do: %BowlingV1{rolls: [], frame: 1, complete: false}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(t, integer) :: {:ok, t} | {:error, String.t}
  def roll(game, roll) when roll >= 0 and roll <= 10, do:
    (if length(game.rolls) >= 20 and Enum.at(game.rolls, 18) !== 10 and Enum.at(game.rolls, 18) + Enum.at(game.rolls, 19) !== 10 do
      {:error, "Cannot roll after game is over"}
    else
      if complete?(game) do
        {:ok, %{game | complete: true}}
      else
        cond do:
        (
          #bonus case
          length(game.rolls) >= 20 and Enum.at(game.rolls, 18) == 10 and Enum.at(game.rolls, 19) < 10 and Enum.at(game.rolls, -1) + roll > 10 ->
            {:error, "Pin count exceeds pins on the lane"}
          # normal case
          rem(length(game.rolls), 2) == 1 and Enum.at(game.rolls, -1) + roll > 10 and Enum.at(game.rolls, -1) != 10 ->
            {:error, "Pin count exceeds pins on the lane"}
          true ->
            {:ok, %{game | rolls: game.rolls ++ [roll], frame: new_frame(game, roll)}}
        )
      end
    end)

  def roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}

  def roll(_, roll) when roll > 10, do: {:error, "Pin count exceeds pins on the lane"}

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
  def score(game) when game.frame < 10, do: {:error, "Score cannot be taken until the end of the game"}

  def score(game), do: {:ok, calculate(game.rolls)}

  defp calculate(rolls), do: calculate(rolls, 0, 1)

  defp calculate([], score, _frames), do: score

  # Strike case: 10 + next two rolls
  defp calculate([10 | tail], score, frame) when frame < 10, do: calculate(tail, score + 10 + next_two(tail), frame + 1)

  # Spare case: 10 + next roll
  defp calculate([first, second | tail], score, frame) when frame < 10 and first + second == 10 do
    bonus = case tail do
      [next | _] -> next
      _ -> 0
    end
    calculate(tail, score + 10 + bonus, frame + 1)
  end

  # Open frame
  defp calculate([first, second | tail], score, frame) when frame < 10, do: calculate(tail, score + first + second, frame + 1)

  # Handle spesial case (spare or strike) at final frame
  defp calculate([first, second | tail], score, 10), do: (
    case tail, do:
    (
      [bonus | _] -> score + first + second + bonus
      _ -> score + first + second
    )
  )

  defp calculate([first | _], score, 10), do: first + score

  defp next_two([first, second | _]), do: first + second

  defp next_two([first | _]), do: first

  defp next_two([]), do: 0

  defp complete?(game), do: (
    if game.frame < 10, do:
      false,
    else:
      (
        case {length(game.rolls), special?(game.rolls)}, do:
        (
          {20, false} -> true
          {21, true} -> true
          {22, _} -> true
          _ -> false
        )
      )
  )

  defp special?(rolls), do: rolls |> Enum.at(18) |> Kernel.==(10) or (Enum.at(rolls, 18) || 0) + (Enum.at(rolls, 19) || 0) == 10

  defp new_frame(game, roll), do: (
    case {game.frame, length(game.rolls) |> rem(2), roll}, do:
      (
        {10, _, _} -> game.frame
        {_, 0, 10} -> game.frame + 1
        {_, 1, _} -> game.frame + 1
        _ -> game.frame
      )
  )
end
