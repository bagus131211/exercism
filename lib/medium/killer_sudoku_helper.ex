defmodule Exercism.KillerSudokuHelper do
  @moduledoc """
  A friend of yours is learning how to solve Killer Sudokus (rules below) but struggling to figure out which digits can go in a cage.
  They ask you to help them out by writing a small program that lists all valid combinations for a given cage,
  and any constraints that affect the cage.

  To make the output of your program easy to read, the combinations it returns must be sorted.

  Killer Sudoku Rules
    Standard Sudoku rules apply.
    The digits in a cage, usually marked by a dotted line, add up to the small number given in the corner of the cage.
    A digit may only occur once in a cage.
    For a more detailed explanation, check out this guide.

  Example 1: Cage with only 1 possible combination
    In a 3-digit cage with a sum of 7, there is only one valid combination: 124.

    1 + 2 + 4 = 7
    Any other combination that adds up to 7, e.g. 232, would violate the rule of not repeating digits within a cage.
      Sudoku grid, with three killer cages that are marked as grouped together.
      The first killer cage is in the 3×3 box in the top left corner of the grid.
      The middle column of that box forms the cage, with the followings cells from top to bottom: first cell contains a 1 and a pencil mark of 7, indicating a cage sum of 7, second cell contains a 2, third cell contains a 5.
      The numbers are highlighted in red to indicate a mistake.
      The second killer cage is in the central 3×3 box of the grid.
      The middle column of that box forms the cage, with the followings cells from top to bottom: first cell contains a 1 and a pencil mark of 7, indicating a cage sum of 7, second cell contains a 2, third cell contains a 4.
      None of the numbers in this cage are highlighted and therefore don't contain any mistakes.
      The third killer cage follows the outside corner of the central 3×3 box of the grid.
      It is made up of the following three cells: the top left cell of the cage contains a 2, highlighted in red, and a cage sum of 7.
      The top right cell of the cage contains a 3.
      The bottom right cell of the cage contains a 2, highlighted in red. All other cells are empty.

  Example 2: Cage with several combinations
    In a 2-digit cage with a sum 10, there are 4 possible combinations:

    19
    28
    37
    46
      Sudoku grid, all squares empty except for the middle column, column 5, which has 8 rows filled.
      Each continguous two rows form a killer cage and are marked as grouped together.
      From top to bottom: first group is a cell with value 1 and a pencil mark indicating a cage sum of 10, cell with value 9.
      Second group is a cell with value 2 and a pencil mark of 10, cell with value 8.
      Third group is a cell with value 3 and a pencil mark of 10, cell with value 7.
      Fourth group is a cell with value 4 and a pencil mark of 10, cell with value 6.
      The last cell in the column is empty.

  Example 3: Cage with several combinations that is restricted
    In a 2-digit cage with a sum 10, where the column already contains a 1 and a 4, there are 2 possible combinations:

    28
    37
    19 and 46 are not possible due to the 1 and 4 in the column according to standard Sudoku rules.

      Sudoku grid, all squares empty except for the middle column, column 5, which has 8 rows filled.
      The first row contains a 4, the second is empty, and the third contains a 1.
      The 1 is highlighted in red to indicate a mistake.
      The last 6 rows in the column form killer cages of two cells each.
      From top to bottom: first group is a cell with value 2 and a pencil mark indicating a cage sum of 10, cell with value 8.
      Second group is a cell with value 3 and a pencil mark of 10, cell with value 7.
      Third group is a cell with value 1, highlighted in red, and a pencil mark of 10, cell with value 9.

  Trying it yourself
    If you want to give an approachable Killer Sudoku a go,
    you can try out this puzzle by Clover, featured by Mark Goodliffe on Cracking The Cryptic on the 21st of June 2021.

    You can also find Killer Sudokus in varying difficulty in numerous newspapers, as well as Sudoku apps, books and websites.

  Credit
    The screenshots above have been generated using F-Puzzles.com, a Puzzle Setting Tool by Eric Fox.
  """

  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(cage), do:
    1..9
     |> Enum.filter(&not Enum.member?(cage.exclude, &1))
     |> Enum.filter(& &1 <= cage.sum)
     |> combine(cage.size, cage.sum)

  defp combine(numbers, size, sum), do:
    (
      case size, do:
      (
        s when s == 1 -> numbers |> Enum.filter(& &1 == sum) |> Enum.map(&[&1])
        _ ->
          for n <- numbers,
              rest <- numbers |> Enum.filter(& &1 > n) |> combine(size - 1, sum - n),
              do: [n | rest]
      )
    )
end
