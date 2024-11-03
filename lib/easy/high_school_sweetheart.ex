defmodule Exercism.HighSchoolSweetheart do
  def first_letter(name), do: name |> String.trim |> String.first

  def initial(name), do: name |> first_letter |> String.upcase |> Kernel.<>(".")

  def initials(full_name), do:
  full_name |> String.split(" ") |> Enum.map(&initial/1) |> Enum.join(" ")

  def pair(full_name1, full_name2), do: initials(full_name1) |>
  (&
  """
      ******       ******
    **      **   **      **
  **         ** **         **
 **            *            **
 **                         **
 **     #{&1}  +  #{initials(full_name2)}     **
  **                       **
    **                   **
      **               **
        **           **
          **       **
            **   **
              ***
               *
 """
  ).()
end
