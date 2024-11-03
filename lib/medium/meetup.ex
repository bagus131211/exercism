defmodule Exercism.Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
  :monday
  | :tuesday
  | :wednesday
  | :thursday
  | :friday
  | :saturday
  | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekday %{
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule), do:
    1..(Date.new!(year, month, 1) |> Date.days_in_month)
      |> Enum.filter(&Date.new!(year, month, &1) |> Date.day_of_week == @weekday[weekday])
      |> Enum.map(&Date.new!(year, month, &1))
      |> (& case schedule, do:
            (
              :first -> &1 |> List.first
              :second -> &1 |> Enum.at(1)
              :third -> &1 |> Enum.at(2)
              :fourth -> &1 |> Enum.at(3)
              :last -> &1 |> List.last
              :teenth -> &1 |> Enum.find(fn d -> d.day >= 13 and d.day <= 19 end)
            )
          ).()
end
