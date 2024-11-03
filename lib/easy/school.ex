defmodule Exercism.School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: %{
    optional(integer) => [String.t]
  }

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new(), do: %{}

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(_school, _name, grade) when grade < 1, do: {:error, "Grade must be positive integer."}

  def add(school, name, grade) do
   if Enum.any?(school, &check_name(&1, name)) do
     {:error, school}
   else
    updated = Map.update(school, grade, [name], fn students -> [name | students] end)
    {:ok, updated}
   end
  end

  defp check_name({_grade, students}, name), do: name in students

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade), do:
    (case school[grade], do:
      (
        nil -> []
        students -> students |> Enum.sort
      )
    )

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school), do: school |> Enum.sort_by(&elem(&1, 0)) |> Enum.flat_map(&roster_student/1)

  defp roster_student({_grade, students}), do: Enum.sort(students)
end
