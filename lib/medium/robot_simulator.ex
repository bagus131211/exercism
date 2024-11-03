defmodule Exercism.RobotSimulator do
  @moduledoc """
  Instructions
  Write a robot simulator.

  A robot factory's test facility needs a program to verify robot movements.

  The robots have three possible movements:

    turn right
    turn left
    advance
  Robots are placed on a hypothetical infinite grid, facing a particular direction (north, east, south, or west) at a set of
  {x,y} coordinates, e.g., {3,8}, with coordinates increasing to the north and east.

  The robot then receives a number of instructions, at which point the testing facility verifies the robot's new position,
  and in which direction it is pointing.

  The letter-string "RAALAL" means:
    Turn right
    Advance twice
    Turn left
    Advance once
    Turn left yet again
    Say a robot starts at {7, 3} facing north. Then running this stream of instructions should leave it at {9, 4} facing west.

  """

  @type robot() :: any()
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @directions [:north, :east, :south, :west]

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`

    Example:

      iex(15)> Exercism.RobotSimulator.create
      %{position: {0, 0}, direction: :north}

      iex(38)> Exercism.RobotSimulator.create :invalid, {0,1}
      {:error, "invalid direction"}

      iex(41)> Exercism.RobotSimulator.create :west, {"0",1}
      {:error, "invalid position"}

  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _) when direction not in [:north, :west, :east, :south], do: {:error, "invalid direction"}

  def create(_, position) when not is_tuple(position) or tuple_size(position) != 2, do: {:error, "invalid position"}

  def create(_, {x, y}) when not is_integer(x) or not is_integer(y), do: {:error, "invalid position"}

  def create(direction, position), do: %{direction: direction, position: position}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)

    Example:

      iex(18)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("R") |> Exercism.RobotSimulator.simulate("R") |> Exercism.RobotSimulator.simulate("R")
      %{position: {0, 0}, direction: :west}

      iex(19)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("RRRR")
      %{position: {0, 0}, direction: :north}

      iex(20)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("RRRRR")
      %{position: {0, 0}, direction: :east}

      iex(31)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("L")
      %{position: {0, 0}, direction: :west}

      iex(32)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("LL")
      %{position: {0, 0}, direction: :south}

      iex(33)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("RR")
      %{position: {0, 0}, direction: :south}

      iex(34)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("LLL")
      %{position: {0, 0}, direction: :east}

      iex(35)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("RRR")
      %{position: {0, 0}, direction: :west}

      iex(36)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("LAAARALA")
      %{position: {-4, 1}, direction: :west}

      iex(37)> Exercism.RobotSimulator.create |> Exercism.RobotSimulator.simulate("LAAARALAU")
      {:error, "invalid instruction"}

  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions), do: instructions |> String.graphemes |> Enum.reduce(robot, &process/2)

  defp process(_, {:error, _} = error), do: error

  defp process("R", robot), do: robot |> turn_right

  defp process("L", robot), do: robot |> turn_left

  defp process("A", robot), do: robot |> advance

  defp process(_, _), do: {:error, "invalid instruction"}

  defp turn_right(robot), do: %{robot | direction: next_movement(robot.direction, 1)}

  defp turn_left(robot), do: %{robot | direction: next_movement(robot.direction, -1)}

  defp advance(%{position: {x, y}} = robot), do:
    %{robot | position: (case robot.direction, do:
      (
        :north -> {x, y + 1}
        :east -> {x + 1, y}
        :south -> {x, y - 1}
        :west -> {x - 1, y}
      )
    )}

  defp next_movement(direction, step), do: @directions |> Enum.at(rem(Enum.find_index(@directions, & &1 == direction) + step + 4, 4))

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`

    Example:

      iex(42)> ro = Exercism.RobotSimulator.create
      %{position: {0, 0}, direction: :north}

      iex(44)> Exercism.RobotSimulator.direction ro
      :north

  """
  @spec direction(robot) :: direction()
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.

    Example:

      iex(42)> ro = Exercism.RobotSimulator.create
      %{position: {0, 0}, direction: :north}

      iex(45)> Exercism.RobotSimulator.position ro
      {0, 0}

  """
  @spec position(robot) :: position()
  def position(robot), do: robot.position
end
