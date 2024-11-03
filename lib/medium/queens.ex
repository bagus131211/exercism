defmodule Exercism.Queens do
  @moduledoc """
  Instructions
  Given the position of two queens on a chess board, indicate whether or not they are positioned so that they can attack each other.

  In the game of chess, a queen can attack pieces which are on the same row, column, or diagonal.

  A chessboard can be represented by an 8 by 8 array.

  So if you are told the white queen is at c5 (zero-indexed at column 2, row 3)
  and the black queen at f2 (zero-indexed at column 5, row 6), then you know that the set-up is like so:

  A chess board with two queens. Arrows emanating from the queen at c5 indicate possible directions of capture along file,
  rank and diagonal.

  You are also able to answer whether the queens can attack each other. In this case, that answer would be yes, they can,
  because both pieces share a diagonal.
  """

  @type t :: %__MODULE__{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens

    Example:

      iex(69)> n = Exercism.Queens.new
      %Exercism.Queens{white: {0, 0}, black: {6, 6}}

  """
  @spec new(Keyword.t()) :: t
  def new(opts \\ []) do
    if opts !== [] and !Keyword.has_key?(opts, :black) and !Keyword.has_key?(opts, :white), do: (raise ArgumentError, "invalid color")
    white = opts[:white]
    black = opts[:black]
    cases(black, white)
    %__MODULE__{black: black, white: white}
  end

  defp cases(_, {a, b}) when a < 0 or b < 0, do: (raise ArgumentError, "queen must have positive column and row")

  defp cases({a, b}, _) when a < 0 or b < 0, do: (raise ArgumentError, "queen must have positive column and row")

  defp cases({a, b}, _) when a > 7 or b > 7, do: (raise ArgumentError, "queen must have row and column on board")

  defp cases(_, {a, b}) when a > 7 or b > 7, do: (raise ArgumentError, "queen must have row and column on board")

  defp cases({a, b}, {c, d}) when a == c and b == d, do: (raise ArgumentError, "cannot occupy same space")

  defp cases(_, _), do: :ok

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown

    Example:

      iex(66)> Exercism.Queens.to_string(n) |> IO.puts
      W _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ B _
      _ _ _ _ _ _ _ _
      :ok

  """
  @spec to_string(t) :: String.t()
  def to_string(%__MODULE__{white: white, black: black}), do:
    (for row <- 0..7, do:
      (
        for col <- 0..7, do:
          cond do:
          (
            {row, col} == white and white !== nil -> "W"
            {row, col} == black and black !== nil -> "B"
            true -> "_"
          )
      )
    )
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")


  @doc """
  Checks if the queens can attack each other

    Example:

      iex(68)> Exercism.Queens.can_attack? n
      true

  """
  @spec can_attack?(t) :: boolean
  def can_attack?(%__MODULE__{white: nil, black: _}), do: false

  def can_attack?(%__MODULE__{white: _, black: nil}), do: false

  def can_attack?(%__MODULE__{white: {w_row, w_col}, black: {b_row, b_col}}), do:
    w_row == b_row or w_col == b_col or abs(w_row - b_row) == abs(w_col - b_col)
end
