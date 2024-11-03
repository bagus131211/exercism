defmodule Exercism.WordSearch do
  @moduledoc """
  Instructions
    In word search puzzles you get a square of letters and have to find specific words in them.

    For example:

      jefblpepre
      camdcimgtc
      oivokprjsm
      pbwasqroua
      rixilelhrs
      wolcqlirpc
      screeaumgr
      alxhpburyi
      jalaycalmp
      clojurermt
    There are several programming languages hidden in the above square.

    Words can be hidden in all kinds of directions: left-to-right, right-to-left, vertical and diagonal.

    Given a puzzle and a list of words return the location of the first and last letter of each word.
  """

  defmodule Location do
    defstruct [:from, :to]

    @type t :: %Location{from: %{row: integer, column: integer}, to: %{row: integer, column: integer}}
  end

  @direction [
    {-1, -1}, {-1, 0}, {-1, 1},
    {0, -1},           {0, 1},
    {1, -1},  {1, 0},  {1, 1}
  ]

  @doc """
  Find the start and end positions of words in a grid of letters.
  Row and column positions are 1 indexed.

    ## Example:

      iex(17)> Exercism.WordSearch.search "clojurermt", ["clojure"]
      %{
        "clojure" => %Exercism.WordSearch.Location{
          from: %{column: 1, row: 1},
          to: %{column: 7, row: 1}
        }
      }

      iex(18)> Exercism.WordSearch.search "jefblpepre", ["clojure"]
      %{"clojure" => nil}

      iex(19)> Exercism.WordSearch.search "mtclojurer", ["clojure"]
      %{
        "clojure" => %Exercism.WordSearch.Location{
          from: %{column: 3, row: 1},
          to: %{column: 9, row: 1}
        }
      }

      iex(84)> Exercism.WordSearch.search "jefblpepre\ntclojurerm\n", ["clojure"]
      %{
        "clojure" => %Exercism.WordSearch.Location{
          from: %{column: 2, row: 2},
          to: %{column: 8, row: 2}
        }
      }

      iex(109)> Exercism.WordSearch.search "jefblpepre\ncamdcimgtc\noivokprjsm\npbwasqroua\nrixilelhrs\nwolcqlirpc\nfortranftw\nalxhpburyi\njalaycalmp\nclojurermt\n", ["clojure", "fortran"]
      %{
        "clojure" => %Exercism.WordSearch.Location{
          from: %{column: 1, row: 10},
          to: %{column: 7, row: 10}
        },
        "fortran" => %Exercism.WordSearch.Location{
          from: %{column: 1, row: 7},
          to: %{column: 7, row: 7}
        }
      }

      iex(114)> Exercism.WordSearch.search "rixilehrs", ["elixir"]
      %{
        "elixir" => %Exercism.WordSearch.Location{
          from: %{column: 6, row: 1},
          to: %{column: 1, row: 1}
        }
      }

      iex(1)> Exercism.WordSearch.search "jefblpepre\ncamdcimgtc\noivokprjsm\npbwasqroua\nrixilelhrs\nwolcqlirpc\nscreeaumgr\nalxhpburyi\njalaycalmp\nclojurermt\n", ["elixir", "clojure"]
      %{
        "clojure" => %Exercism.WordSearch.Location{
          from: %{column: 1, row: 10},
          to: %{column: 7, row: 10}
        },
        "elixir" => %Exercism.WordSearch.Location{
          from: %{column: 6, row: 5},
          to: %{column: 1, row: 5}
        }
      }

      iex(170)> Exercism.WordSearch.search "jefblpepre\ncamdcimgtc\noivokprjsm\npbwasqroua\nrixilelhrs\nwolcqlirpc\nscreeaumgr\nalxhpburyi\njalaycalmp\nclojurermt\n", ["clojure", "elixir", "ecmascript", "rust", "java", "lua"]
      %{
        "clojure" => %Exercism.WordSearch.Location{
          from: %{column: 1, row: 10},
          to: %{column: 7, row: 10}
        },
        "ecmascript" => %Exercism.WordSearch.Location{
          from: %{column: 10, row: 1},
          to: %{column: 10, row: 10}
        },
        "elixir" => %Exercism.WordSearch.Location{
          from: %{column: 6, row: 5},
          to: %{column: 1, row: 5}
        },
        "java" => %Exercism.WordSearch.Location{
          from: %{column: 1, row: 1},
          to: %{column: 4, row: 4}
        },
        "lua" => %Exercism.WordSearch.Location{
          from: %{column: 8, row: 9},
          to: %{column: 6, row: 7}
        },
        "rust" => %Exercism.WordSearch.Location{
          from: %{column: 9, row: 5},
          to: %{column: 9, row: 2}
        }
      }

  """
  @spec search(grid :: String.t(), words :: [String.t()]) :: %{String.t() => nil | Location.t()}
  def search(grid, words), do: grid |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1) |> positions(words)

  defp positions(list, words), do: (
    for word <- words, into: %{}, do:
      (
        alphabets = word |> String.graphemes
        alphabet_last_index = alphabets |> length |> Kernel.-(1)
        for row_index <- 0..(list |> length |> Kernel.-(1)),
            column_index <- 0..(list |> hd |> length |> Kernel.-(1)),
            {x, y} <- @direction, do:
              (
                end_row = row_index + x * alphabet_last_index
                end_column = column_index + y * alphabet_last_index
                if end_row >= 0 and
                   end_column >= 0 and
                   end_row < length(list) and
                   end_column < length(hd(list)) and
                   alphabets == (for i <- 0..alphabet_last_index, do: list |> Enum.at(row_index + x * i) |> Enum.at(column_index + y * i)), do:
                    %Location{from: %{row: row_index + 1, column: column_index + 1}, to: %{row: end_row + 1, column: end_column + 1}}
              )
      )
    |> Enum.find_value(& &1)
    |> then(&{word, &1})
  )


  # ------------------------------------------- Alternatives --------------------------------------------------------------
  def search_alt(grid, words), do: words |> Enum.reduce(%{}, fn word, acc ->
    case search_word(grid, word), do:
    (
      nil -> Map.put(acc, word, nil)
      location -> Map.put_new(acc, word, location)
    )
  end)

  defp search_word(grid, word), do:
    grid
      |> String.split("\n")
      |> reduce_while(word)

  defp reduce_while(rows, word), do:
    rows
      |> Enum.with_index
      |> Enum.reduce_while(nil, fn {row, row_index}, _acc ->
        case find_by_row(row, word), do:
        (
          {:ok, start, length, reversed} ->
            {:halt, %Location{
              from: %{row: row_index + 1, column: (if reversed, do: start + length, else: start + 1)},
              to: %{row: row_index + 1, column: (if reversed, do: start + 1, else: start + length)}}}
          :error ->
            case find_by_column(rows, word, row_index), do:
            (
              {:ok, column_index, length, reversed} ->
                {:halt, %Location{
                  from: %{row: (if reversed, do: column_index + length, else: column_index + 1), column: row_index + 1},
                  to: %{row: (if reversed, do: column_index + 1, else: column_index + length), column: row_index + 1}}}
              :error ->
                case find_by_diagonal(rows, word), do:
                (
                  {:ok, {start_row, start_column}, {end_row, end_column}} ->
                    {:halt, %Location{from: %{row: start_row + 1, column: start_column + 1}, to: %{row: end_row + 1, column: end_column + 1}}}
                  :error ->
                     {:cont, nil}
                )
            )
        )
      end)

  defp find_by_row(row, word), do:
    (case row |> :binary.match(word), do:
      (
        {start, length} -> {:ok, start, length, false}
        :nomatch -> row |> String.reverse |> find_by_reversed_row(word)
      )
    )

  defp find_by_reversed_row(row, word), do:
    (case row |> :binary.match(word), do:
      (
        {start, length} -> {:ok, String.length(row) - start - length, length, true}
        :nomatch -> :error
      )
    )

  defp find_by_column(rows, word, column_index), do:
    rows |> Enum.map(&String.at(&1, column_index)) |> then(
      &case &1 |> Enum.join |> :binary.match(word), do:
      (
        {start, length} -> {:ok, start, length, false}
        :nomatch -> &1 |> Enum.reverse |> Enum.join |> find_by_reversed_column(word)
      )
    )

  defp find_by_reversed_column(column, word), do:
    (case column |> :binary.match(word), do:
      (
        {start, length} -> {:ok, String.length(column) - start - length, length, true}
        :nomatch -> :error
      )
    )

  defp find_by_diagonal(rows, word), do:
    rows
      |> diagonals
      |> Enum.reduce_while(:error, fn {diagonal, start_row, start_column}, acc ->
        case diagonal |> Enum.join |> :binary.match(word), do:
          (
            {start, length} ->
              IO.inspect({word, start_row, start_column, start, length})
              {:halt, {:ok,
                {start_row + start, start_column + start} |> IO.inspect(label: word),
                {start_row + start + length - 1, start_column + start + length - 1} |> IO.inspect(label: word)
                }
              }
            :nomatch -> diagonal |> Enum.reverse |> Enum.join |> find_by_reversed_diagonal(start_row, start_column, acc, word)
          )
      end)

  defp find_by_reversed_diagonal(diagonal, start_row, start_column, acc, word), do:
      (
        case diagonal |> :binary.match(word), do:
        (
          {start, _length} ->
            {:halt, {:ok,
              {start_row + String.length(diagonal) - start - 1, start_column + String.length(diagonal) - start - 1},
              {start_row + String.length(diagonal) - start - String.length(word), start_column + String.length(diagonal) - start - String.length(word)}
              }
            }
          :nomatch -> {:cont, acc}
        )
      )

  defp diagonals(rows) do
    len = length(rows)

    top_left_to_bottom_right = for i <- 0..(len - 1), do:
      (
        diagonal = for j <- 0..(len - 1), do:
          (if i + j < len and j < len, do: rows |> Enum.at(i + j) |> String.at(j), else: nil)
        {diagonal |> Enum.reject(&is_nil/1), i, 0}
      )

    bottom_left_to_top_right = for i <- 0..(len - 1), do:
      (
        diagonal = for j <- 0..(len - 1), do:
          (if i - j >= 0 and j < len, do: rows |> Enum.at(i - j - 1) |> String.at(j), else: nil)
        {diagonal |> Enum.reject(&is_nil/1), len - i - 1, 0}
      )

    top_left_to_bottom_right ++ bottom_left_to_top_right |> IO.inspect(label: "dia")
  end
end
