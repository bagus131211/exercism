defmodule Exercism.Garden do
  @moduledoc """
  Your task is to, given a diagram, determine which plants each child in the kindergarten class is responsible for.

  There are 12 children in the class:

  Alice, Bob, Charlie, David, Eve, Fred, Ginny, Harriet, Ileana, Joseph, Kincaid, and Larry.
  Four different types of seeds are planted:

    Plant	Diagram encoding
    Grass	G
    Clover	C
    Radish	R
    Violet	V
  Each child gets four cups, two on each row:

    [window][window][window]
    ........................ # each dot represents a cup
    ........................
  Their teacher assigns cups to the children alphabetically by their names, which means that Alice comes first and Larry comes last.

  Here is an example diagram representing Alice's plants:

    [window][window][window]
    VR......................
    RG......................
  In the first row, nearest the windows, she has a violet and a radish. In the second row she has a radish and some grass.

  Your program will be given the plants from left-to-right starting with the row nearest the windows. From this, it should be able to determine which plants belong to each student.

  For example, if it's told that the garden looks like so:

    [window][window][window]
    VRCGVVRVCGGCCGVRGCVCGCGV
    VRCCCGCRRGVCGCRVVCVGCGCV
  Then if asked for Alice's plants, it should provide:

  Violets, radishes, violets, radishes
  While asking for Bob's plants would yield:

  Clover, grass, clover, clover
  """
  @plant %{
    "R" => :radishes,
    "C" => :clover,
    "G" => :grass,
    "V" => :violets
  }

  @students [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Fred",
    "Ginny",
    "Harriet",
    "Ileana",
    "Joseph",
    "Kincaid",
    "Larry"
  ]

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @students), do:
    info_string
    |> String.split("\n")
    |> process_garden(student_names)
    |> map_others(student_names)

  defp process_garden(gardens, students) do
    [first_row, second_row] = gardens

    students
    |> Enum.sort
    |> Enum.map(&downcase/1)
    |> Enum.map(&String.to_atom/1)
    |> Enum.zip(
       # Chunk first and second row into plant pairs and combine them
       Enum.zip(Enum.chunk_every(String.graphemes(first_row), 2), Enum.chunk_every(String.graphemes(second_row), 2))
       |> Enum.map(&concat/1)  # Merge rows into pairs
       |> Enum.map(&Enum.map(&1, fn p -> @plant[p] end))           # Convert plant letters to atoms
       |> Enum.map(&List.to_tuple/1)
       )
    |> Enum.into(%{})
  end

  defp concat({row1, row2}), do: row1 ++ row2

  defp map_others(garden, students), do: students |> Enum.reduce(garden, &new_map/2)

  defp downcase(student), do: (if is_atom(student), do: student |> Atom.to_string |> String.downcase, else: String.downcase(student))

  defp new_map(student, acc), do:
   Map.put_new(acc, student |> downcase |> String.to_atom, {})
end
